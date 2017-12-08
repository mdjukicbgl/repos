using System.IO;
using Microsoft.AspNetCore.Hosting;

namespace Markdown.WebApi
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var host = new WebHostBuilder()
                .UseKestrel()
                .UseContentRoot(Directory.GetCurrentDirectory())
                .UseIISIntegration()
                .UseStartup<Startup>()
                .CaptureStartupErrors(true)
                .UseSetting("detailedErrors", "true")
                .UseUrls("http://*:5000")
                .Build();

            host.Run();
        }
    }
}
