using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Amazon.S3;
using Amazon.S3.Model;
using Amazon.S3.Transfer;
using Markdown.Common.Interfaces;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using Serilog;

namespace Markdown.Data.Repository.S3
{
    public class S3JsonRepository : S3BaseRepository, IS3Repository
    {
        private readonly ILogger _logger;
        private readonly IAmazonS3 _s3Client;

        public S3JsonRepository(ILogger logger, IAmazonS3 s3Client) : base(logger, s3Client)
        {
            _logger = logger.ForContext<S3JsonRepository>();
            _s3Client = s3Client;
        }

        public async Task WriteRecord<T>(IS3Path path, T record)
        {
            await WriteRecords(path, new List<T> { record });
        }

        public async Task WriteRecords<T>(IS3Path path, IEnumerable<T> records)
        {
            _logger.Information("Writing {Type} records to {@S3Path}", typeof(T).Name, path);

            var recordCount = 0;
            var serializerSettings = new JsonSerializerSettings();
            serializerSettings.Converters.Add(new StringEnumConverter());

            var serializer = JsonSerializer.Create(serializerSettings);
            using (var memoryStream = new MemoryStream())
            {
                using (var sw = new StreamWriter(memoryStream, Encoding.UTF8, 1024, true))
                {
                    // Write all objects
                    using (var jsonWriter = new JsonTextWriter(sw))
                    {
                        foreach (var record in records)
                        {
                            serializer.Serialize(jsonWriter, record);
                            jsonWriter.WriteRaw("\n");
                            recordCount++;
                        }
                    }

                    memoryStream.Position = 0;

                    _logger.Debug("Uploading {RecordCount} {Type} records to S3 HierarchyPath: {@S3Path}", typeof(T).Name, recordCount, path);
                    var transferUtility = new TransferUtility(_s3Client);
                    await transferUtility.UploadAsync(new TransferUtilityUploadRequest
                    {
                        BucketName = path.BucketName,
                        Key = path.Key,
                        InputStream = memoryStream
                    }, CancellationToken.None);
                }
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

            var serializerSettings = new JsonSerializerSettings();
            serializerSettings.Converters.Add(new StringEnumConverter());

            var results = new List<T>();
            try
            {
                using (var response = await _s3Client.GetObjectAsync(new GetObjectRequest { BucketName = path.BucketName, Key = path.Key }))
                {
                    using (var responseStream = response.ResponseStream)
                    {
                        using (var streamReader = new StreamReader(responseStream))
                        {
                            string line;
                            while ((line = await streamReader.ReadLineAsync()) != null)
                            {
                                results.Add(JsonConvert.DeserializeObject<T>(line, serializerSettings));
                            }
                        }
                    }
                }
            }
            catch (AmazonS3Exception ex)
            {
                if (ex.ErrorCode == "NoSuchKey" && isOptional)
                    return new List<T>();

                throw new System.Exception("A error occured accessing key (" + path.Key + ") in bucket (" + path.BucketName + "): " + ex.ErrorCode, ex);
            }

            if (predicate != null)
                results = results.Where(predicate).ToList();

            _logger.Information("Read {Count} {Type} records from {@S3Path}", results.Count, typeof(T).Name, path);
            return results;
        }
    }
}