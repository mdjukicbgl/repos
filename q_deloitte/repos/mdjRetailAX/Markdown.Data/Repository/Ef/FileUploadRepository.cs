using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Markdown.Data.Entity.App;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using FileUploadType = Markdown.Common.Enums.FileUploadType;

namespace Markdown.Data.Repository.Ef
{
    public interface IFileUploadRepository
    {
        Task<FileUpload> Start(string presignedUrl, TimeSpan ttl, Guid guid, FileUploadType type, string name, long size, DateTime lastModifiedDate);
        Task<bool> Finish(Guid guid);
        Task<bool> Abort(Guid guid);
        Task<FileUpload> GetByGuid(Guid guid);
    }

    public class FileUploadRepository : BaseEntityRepository<Hierarchy>, IFileUploadRepository
    {
        public FileUploadRepository(IDbContextFactory<MarkdownEfContext> contextFactory) : base(contextFactory)
        {
        }

        public async Task<FileUpload> Start(string presignedUrl, TimeSpan ttl, Guid guid, FileUploadType type, string name, long size, DateTime lastModifiedDate)
        {
            var now = DateTime.UtcNow;
            var entity = new FileUpload
            {
                Guid = guid,
                PresignedUrl = presignedUrl,

                FileUploadTypeId = (int)type,
                Name = name,
                Size = size,
                StartDate = now,
                ExpirationDate = now + ttl,
                LastModifiedDate = lastModifiedDate
            };

            Context.FileUploads.Add(entity);
            await Context.SaveChangesAsync();
            return entity;
        }

        public async Task<bool> Finish(Guid guid)
        {
            var entity = Context.FileUploads.FirstOrDefault(x => x.Guid == guid);
            if (entity == null)
                return false;
            entity.FinishDate = DateTime.UtcNow;
            Context.FileUploads.Update(entity);
            await Context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> Abort(Guid guid)
        {
            var entity = Context.FileUploads.FirstOrDefault(x => x.Guid == guid);
            if (entity == null)
                return false;
            entity.FinishDate = DateTime.UtcNow;
            entity.IsAborted = true;
            Context.FileUploads.Update(entity);
            await Context.SaveChangesAsync();
            return true;
        }

        public async Task<FileUpload> GetByGuid(Guid guid)
        {
            return await Context.FileUploads
                .Where(x => x.Guid == guid)
                .FirstOrDefaultAsync();
        }
    }
}
