using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Amazon.Lambda.Core;
using Markdown.Function.Main;
using Microsoft.Extensions.Configuration;

namespace Markdown.Function
{
    public class Program
    {
        public static IConfigurationRoot Configuration { get; set; }

        [LambdaSerializer(typeof(Amazon.Lambda.Serialization.Json.JsonSerializer))]
        public static async Task AWSMain(Dictionary<string, string> configuration, ILambdaContext context)
        {
            var args = new string[0];
            var program = configuration["Program"];

            switch (program)
            {
                case "calc":
                    await Calculate.Start(program, args, configuration, context);
                    break;
                case "model":
                    await Model.Start(program, args, configuration, context);
                    break;
                case "partition":
                    await Partition.Start(program, args, configuration, context);
                    break;
                case "upload":
                    await Upload.Start(program, args, configuration, context);
                    break;
                default:
                    throw new ArgumentException("Unknown program commandline switch", nameof(program));
            }
        }

        public static void Main(string[] args)
        {
            Task.Run(async () => {
                var parameters = new Dictionary<string, string>
                {
                    {"--Program", "Program"},
                    {"--Pause", "Pause"}
                };

                var builder = new ConfigurationBuilder()
                    .AddCommandLine(args, parameters);

                var configuration = builder.Build();
                var program = configuration["Program"] ?? string.Empty;
                int.TryParse(configuration["Pause"], out int pause);

                switch (program.ToLower())
                {
                    case "model":
                        await Model.Start(program, args);
                        break;
                    case "partition":
                        await Partition.Start(program, args);
                        break;
                    case "calc":
                        await Calculate.Start(program, args);
                        break;
                    case "upload":
                        await Upload.Start(program, args);
                        break;
                    default:
                        throw new ArgumentException("Unknown program commandline switch", nameof(program));
                }

                if (pause > 0)
                {
                    Console.WriteLine(Environment.NewLine);
                    Console.WriteLine("Finished. Press any key to exit.");
                    Console.ReadKey();
                }
            })
            .GetAwaiter()
            .GetResult();            
        }
    }
}