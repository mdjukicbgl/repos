using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading;
using System.Threading.Tasks;
using Amazon.S3;
using Amazon.S3.Model;
using Amazon.S3.Transfer;
using CsvHelper;
using CsvHelper.Configuration;
using Markdown.Common.Classes;
using Markdown.Common.Extensions;
using Markdown.Common.Interfaces;
using Serilog;

namespace Markdown.Data.Repository.S3
{
    public interface IS3CsvRepository : IS3Repository
    {

    }

    public class S3CsvRepository : S3BaseRepository, IS3CsvRepository
    {
        private readonly ILogger _logger;
        private readonly IAmazonS3 _s3Client;

        public S3CsvRepository(ILogger logger, IAmazonS3 s3Client) : base(logger, s3Client)
        {
            _logger = logger.ForContext<S3CsvRepository>();
            _s3Client = s3Client;
        }

        //
        // CSV
        //
        public async Task WriteRecord<T>(IS3Path path, T record)
        {
            await WriteRecords(path, new List<T> { record });
        }

        public async Task WriteRecords<T>(IS3Path path, IEnumerable<T> records)
        {
            _logger.Information("Writing {Type} records to {@S3Path}", typeof(T).Name, path);

            var configuration = new CsvConfiguration
            {
                Delimiter = "|",
                QuoteNoFields = true
            };

            var customerMap = new DefaultCsvClassMap<T>();
            foreach (var prop in typeof(T).GetProperties())
            {
                var name = prop.Name.ToSnakeCase();
                var map = new CsvPropertyMap(prop).Name(name);
                customerMap.PropertyMaps.Add(map);
            }
            configuration.RegisterClassMap(customerMap);


            var recordCount = 0;

            using (var temp = new TempFile(".md-ra-poc.csv"))
            {
                _logger.Debug("Writing records to temp path {TempPath}", temp.FullPath);
             
                using (var textWriter = File.CreateText(temp.FullPath))
                {
                    using (var csvWriter = new CsvWriter(textWriter, configuration))
                    {
                        // Write header manually because WriteHeader append an index
                        foreach (var property in csvWriter.Configuration.Maps[typeof(T)].PropertyMaps)
                            csvWriter.WriteField(property.Data.Names.FirstOrDefault());

                        // Advance past header
                        csvWriter.NextRecord();

                        foreach (var record in records)
                        {
                            csvWriter.WriteRecord(record);
                            csvWriter.NextRecord();
                            recordCount++;
                        }
                    }
                }
             
                _logger.Debug("Wrote CSV to {HierarchyPath}. Records: {Records}. Size: {Bytes} bytes", temp.FullPath, recordCount, new FileInfo(temp.FullPath).Length);

                _logger.Debug("Uploading {TempPath} to S3 HierarchyPath: {@S3Path}", temp.FullPath, path);
                var transferUtility = new TransferUtility(_s3Client);
                await transferUtility.UploadAsync(new TransferUtilityUploadRequest
                {
                    BucketName = path.BucketName,
                    Key = path.Key,
                    FilePath = temp.FullPath
                }, CancellationToken.None);
                _logger.Debug("Uploaded {TempPath} to S3 HierarchyPath: {@S3Path}", temp.FullPath, path);
            }

            _logger.Information("Uploaded {Records} {Type} records to {@S3Path}", recordCount, typeof(T).Name, path);
        }

        public async Task<T> ReadRecord<T>(IS3Path path)
        {
            var results = await ReadRecords<T>(path);
            return results.FirstOrDefault();
        }

        public async Task<List<T>> ReadRecords<T>(IS3Path path, bool isOptional = false)
        {
            return await ReadRecords<T>(path, null, isOptional);
        }

        public async Task<List<T>> ReadRecords<T>(IS3Path path, Func<T, bool> predicate, bool isOptional = false)
        {
            _logger.Information("Reading {Type} records from {@S3Path}", typeof(T).Name, path);

            var configuration = new CsvConfiguration
            {
                Delimiter = "|",
                QuoteNoFields = true,
                HasHeaderRecord = true
            };

            var customerMap = new DefaultCsvClassMap<T>();
            foreach (var prop in typeof(T).GetProperties())
            {
                var name = prop.Name.ToSnakeCase();
                var map = new CsvPropertyMap(prop).Name(name);
                customerMap.PropertyMaps.Add(map);
            }
            configuration.RegisterClassMap(customerMap);

            try
            {
                using (var response = await _s3Client.GetObjectAsync(new GetObjectRequest {BucketName = path.BucketName, Key = path.Key}))
                {
                    using (var responseStream = response.ResponseStream)
                    {
                        using (var streamReader = new StreamReader(responseStream))
                        {
                            using (var reader = new CsvReader(streamReader, configuration))
                            {
                                var results = reader.GetRecords<T>();
                                if (predicate != null)
                                    results = results.Where(predicate);
                                return results.ToList();
                            }
                        }
                    }
                }
            }
            catch (AmazonS3Exception ex)
            {
                if (ex.ErrorCode == "NoSuchKey" && isOptional)
                    return new List<T>();

                throw;
            }
            catch (Exception e)
            {
                _logger.Fatal("Exception when trying to read csv file: {@Message}", e.Message);
                throw;
            }
        }
    }
}