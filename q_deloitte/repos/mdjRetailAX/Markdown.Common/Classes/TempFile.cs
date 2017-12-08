using System;
using System.IO;

namespace Markdown.Common.Classes
{
    public class TempFile : IDisposable
    {
        private readonly string _tmpfile;

        public string FullPath => _tmpfile;

        public TempFile() : this(string.Empty)
        {
        }

        public TempFile(string extension)
        {
            _tmpfile = Path.GetTempFileName();
            if (!string.IsNullOrEmpty(extension))
            {
                var newTmpFile = _tmpfile + extension;

                // delete old tmp-File
                File.Delete(_tmpfile);

                // use new tmp-File
                _tmpfile = newTmpFile;
            }
        }


        void IDisposable.Dispose()
        {
            try
            {
                if (!string.IsNullOrEmpty(_tmpfile) && File.Exists(_tmpfile))
                    File.Delete(_tmpfile);
            }
            catch (Exception /*ex*/)
            {
                // Swallow ex
            }
        }
    }
}
