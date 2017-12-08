using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Markdown.Common.Interfaces;

namespace Markdown.Data.Repository.S3
{
    public interface IS3Repository : IS3BaseRepository
    {        
        Task WriteRecord<T>(IS3Path path, T record);
        Task WriteRecords<T>(IS3Path path, IEnumerable<T> records);
        Task<T> ReadRecord<T>(IS3Path path);
        Task<List<T>> ReadRecords<T>(IS3Path path, bool isOptional = false);
        Task<List<T>> ReadRecords<T>(IS3Path path, Func<T, bool> predicate, bool isOptional = false);
    }
}