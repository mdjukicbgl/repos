using System;
using Markdown.Common.Settings.Interfaces;
using Microsoft.Extensions.Configuration;

namespace Markdown.Common.Settings
{
    public class FileUploadSettings : IFileUploadSettings
    {
        public string BucketName { get; set; }
        public string PathTemplate { get; set; }
        public int ExpiryMinutes { get; set; }

        public FileUploadSettings(string bucketName, string pathTemplate, int expiryMinutes)
        {
            BucketName = bucketName;
            PathTemplate = pathTemplate;
            ExpiryMinutes = expiryMinutes;
        }

        public FileUploadSettings(IConfiguration configuration)
        {
            var settings = configuration.GetSection("Settings");

            var fileUploadBucketName = configuration["FileUploadBucketName"] ?? settings["FileUploadBucketName"];
            if (string.IsNullOrWhiteSpace(fileUploadBucketName))
                throw new Exception("Missing FileUploadBucketName in configuration");
            BucketName = fileUploadBucketName;

            var fileUploadPathTemplate = configuration["FileUploadPathTemplate"] ?? settings["FileUploadPathTemplate"];
            if (string.IsNullOrWhiteSpace(fileUploadPathTemplate))
                throw new Exception("Missing FileUploadPathTemplate in configuration");
            PathTemplate = fileUploadPathTemplate;

            var fileUploadExpiryMinutes = configuration["FileUploadExpiryMinutes"] ?? settings["FileUploadExpiryMinutes"];
            if (!int.TryParse(fileUploadExpiryMinutes, out int expiryMinutes))
                throw new Exception("Missing or bad format FileUploadExpiryMinutes in configuration");
            ExpiryMinutes = expiryMinutes;
        }
    }
}