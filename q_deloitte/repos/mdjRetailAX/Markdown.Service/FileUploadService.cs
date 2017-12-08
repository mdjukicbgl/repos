using System;
using System.Linq;
using System.Threading.Tasks;
using System.Collections.Generic;
using Amazon.S3;
using Amazon.S3.Model;

using Markdown.Common.Enums;
using Markdown.Common.Interfaces;
using Markdown.Common.Settings;
using Markdown.Common.Settings.Interfaces;
using Markdown.Data.Repository.Ef;
using Markdown.Data.Repository.S3;
using Markdown.Service.Models;

namespace Markdown.Service
{
    public interface IFileUploadService
    {
        Task<SmFileUploadAuthorization> Authorize(FileUploadType type, string name, long size, DateTime lastModifiedDate);
        Task<bool> Finish(Guid guid);
        Task<bool> Abort(Guid guid);
        Task<List<SmCsvProduct>> GetContentsByGuid(Guid guid);
        Task<int> useForScenario(Guid FileGuid, int ScenarioId);
    }

    public class FileUploadService : IFileUploadService
    {
        private readonly IAmazonS3 _s3Client;
        private readonly IFileUploadSettings _fileUploadSettings;
        private readonly IFileUploadRepository _fileUploadRepository;
        private readonly IS3Repository _s3Repository;
        private readonly IFileUploadScenarioRepository _fileUploadScenarioRepository;

        public FileUploadService(IAmazonS3 s3Client, IFileUploadSettings fileUploadSettings, IFileUploadRepository fileUploadRepository, IS3CsvRepository s3Repository, IFileUploadScenarioRepository fileUploadScenarioRepository)
        {
            _s3Client = s3Client;
            _fileUploadSettings = fileUploadSettings;
            _fileUploadRepository = fileUploadRepository;
            _s3Repository = s3Repository;
            _fileUploadScenarioRepository = fileUploadScenarioRepository;
        }

        public async Task<SmFileUploadAuthorization> Authorize(FileUploadType type, string name, long size, DateTime lastModifiedDate)
        {
            var ttl = TimeSpan.FromMinutes(_fileUploadSettings.ExpiryMinutes);
            var guid = Guid.NewGuid();
            var path = GenerateUploadPath(_fileUploadSettings.BucketName, _fileUploadSettings.PathTemplate, guid);
            var expirationDate = DateTime.UtcNow.AddMinutes(_fileUploadSettings.ExpiryMinutes);
         
            var url = _s3Client.GetPreSignedURL(new GetPreSignedUrlRequest
            {
                BucketName = path.BucketName,
                Key = path.Key,
                Verb = HttpVerb.PUT,
                Expires = expirationDate
            });

            var entity = await _fileUploadRepository.Start(url, ttl, guid, type, name, size, lastModifiedDate);

            return new SmFileUploadAuthorization
            {
                Url = url,
                Guid = entity.Guid,
                ExpirationDate = expirationDate
            };
        }

        public async Task<bool> Finish(Guid guid)
        {
            return await _fileUploadRepository.Finish(guid);
        }

        public async Task<bool> Abort(Guid guid)
        {
            return await _fileUploadRepository.Abort(guid);
        }

        public async Task<List<SmCsvProduct>> GetContentsByGuid(Guid guid)
        {
            //TODO: possibly redundant
            var fileUpload = await _fileUploadRepository.GetByGuid(guid);
            var path = GenerateUploadPath(_fileUploadSettings.BucketName, _fileUploadSettings.PathTemplate, guid);

            if (fileUpload != null)
            {
                return await _s3Repository.ReadRecords<SmCsvProduct>(path, true);
            }

            return null;
        }

        private SmS3Path GenerateUploadPath(string bucketName, string template, Guid guid)
        {
            var replacement = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            {
                {"Guid", guid.ToString()},
                {"BucketName", bucketName}
            };

            return new SmS3Path
            {
                BucketName = bucketName,
                Key = replacement.Aggregate(template, (acc, x) => acc.Replace("%" + x.Key + "%", x.Value))
            };
        }

        public async Task<int> useForScenario(Guid FileGuid, int ScenarioId)
        {
            var fileUpload = await _fileUploadRepository.GetByGuid(FileGuid);
            var fileUploadScenario = await _fileUploadScenarioRepository.add(fileUpload.FileUploadId, ScenarioId);
            return fileUploadScenario.FileUploadId;
        }

    }
}
