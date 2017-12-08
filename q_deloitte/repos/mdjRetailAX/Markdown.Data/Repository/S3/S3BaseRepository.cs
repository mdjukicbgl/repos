using System;
using System.Linq;
using System.Threading.Tasks;
using Amazon.S3;
using Amazon.S3.Model;
using Markdown.Common.Interfaces;
using Serilog;

namespace Markdown.Data.Repository.S3
{
    public interface IS3BaseRepository
    {
        Task DeletePath(IS3Path path);
    }

    public class S3BaseRepository : IS3BaseRepository
    {
        private readonly ILogger _logger;
        private readonly IAmazonS3 _s3Client;

        public S3BaseRepository(ILogger logger, IAmazonS3 s3Client)
        {
            _logger = logger.ForContext<S3BaseRepository>();
            _s3Client = s3Client;
        }

        public async Task DeletePath(IS3Path path)
        {
            if (string.IsNullOrWhiteSpace(path.Key))
                throw new Exception("No scenario path specified");

            var request = await _s3Client.ListObjectsAsync(new ListObjectsRequest
            {
                BucketName = path.BucketName,
                Prefix = path.Key
            });

            if (request.S3Objects == null || !request.S3Objects.Any())
                return;

            var deleteRequest = new DeleteObjectsRequest()
            {
                BucketName = path.BucketName
            };

            foreach (var item in request.S3Objects)
                deleteRequest.AddKey(item.Key);

            var response = await _s3Client.DeleteObjectsAsync(deleteRequest);

            _logger.Information("Successfully deleted {KeyCount} items", response.DeletedObjects.Count);
        }
    }
}