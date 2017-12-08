#addin "Cake.Incubator"
#addin "Cake.FileHelpers"
#addin "Cake.Npm"

var target = Argument("target", "Default");

var retail_web_directory = Argument("retail_web_directory", "RetailAnalytics.Web");
var markdown_function_directory = Argument("markdown_function_directory", "Markdown.Function");
var markdown_data_postgressql_directory = Argument("markdown_data_postgressql_directory", "Markdown.Data.PostgresSql");

var publish_dir = Argument("publish_dir", "./_publish");

// Install Tasks
Task("Npm.Install.NgCli")
    .Does(() =>
{
    var settings = new NpmInstallSettings();
    settings.Global = true;
    settings.LogLevel = NpmLogLevel.Info;
    settings.Production = false;
    settings.AddPackage("@angular/cli");

    NpmInstall(settings);
});

Task("Npm.Install")
    .Does(() =>
{
    
    using(var process = StartAndReturnProcess("npm", new ProcessSettings { Arguments = "install", WorkingDirectory = Directory("./" + retail_web_directory)})) {
        process.WaitForExit();
        if (process.GetExitCode() > 0) {
            throw new Exception("##vso[task.logissue type=error] Npm Install Failed");
        }        
    }    

    using(var process = StartAndReturnProcess("npm", new ProcessSettings { Arguments = "rebuild node-sass", WorkingDirectory = Directory("./" + retail_web_directory)})) {
        process.WaitForExit();
        if (process.GetExitCode() > 0) {
            throw new Exception("##vso[task.logissue type=error] Npm Rebuild node-sass Failed");
        }        
    }
});

// Build Tasks
Task("Build.Web")
    .IsDependentOn("Npm.Install")
    .Does(() =>
    {
        var processBuilder = new ProcessArgumentBuilder();
        processBuilder.Append("build");
        processBuilder.Append("--aot");
        processBuilder.Append("--env=dev");
        processBuilder.Append("--output-hashing");
        processBuilder.Append("--stats-json");
        using(var process = StartAndReturnProcess("ng", new ProcessSettings { Arguments = processBuilder.Render(), WorkingDirectory = Directory("./" + retail_web_directory) })) {
            process.WaitForExit();
            if (process.GetExitCode() > 0) {
                throw new Exception("##vso[task.logissue type=error] Web Build Failed");
            }
        }
    });
  

Task("Build.Markdown.Data.PostgresSql")
    .Does(() =>
    {
        // 1. Clean up existing script if it exists
        Information("Cleaning PostgresSql Script Directory");
        CleanDirectory("./" + markdown_function_directory + "/Scripts");
        // 2. Concatenate the scripts
        Information("Building Ephemeral Scripts for Lambda");

        if (IsRunningOnWindows()) {
            /*
            var exitCodeBuildSchema = StartProcess("copy", new ProcessSettings { Arguments = "/b ephemeral\\*_schema_*.sql ..\\" + markdown_function_directory + "\\Scripts\\schema_script.sql", WorkingDirectory = Directory(".\\" + markdown_data_postgressql_directory)  });
            if (exitCodeBuildSchema > 0) {
                throw new Exception("##vso[task.logissue type=error] There was an error building the schema script");
            }

            var exitCodeProcSchema = StartProcess("copy", new ProcessSettings { Arguments = @"copy /b ephemeral\\*_procs_*.sql ..\\" + markdown_function_directory + "\\Scripts\\procs_script.sql", WorkingDirectory = Directory(".\\" + markdown_data_postgressql_directory)  });
            if (exitCodeProcSchema > 0) {
                throw new Exception("##vso[task.logissue type=error] There was an error building the proc script");                
            }*/

        } else if (IsRunningOnUnix()) {
            
            var matchingSchemaFiles = GetFiles("./Markdown.Data.PostgresSql/ephemeral/*_schema_*.sql");
            
            foreach(var file in matchingSchemaFiles) {
                Information(file.FullPath);
                FileAppendText("./Markdown.Function/Scripts/schema_script.sql", FileReadText(file.FullPath));                
            }

            var matchingProcFiles = GetFiles("./Markdown.Data.PostgresSql/ephemeral/*_procs_*.sql");
            
            foreach(var file in matchingProcFiles) {
                Information(file.FullPath);
                FileAppendText("./Markdown.Function/Scripts/procs_script.sql", FileReadText(file.FullPath));                
            }            
        }  
    });

Task("Build.DotNetProjects")
    .IsDependentOn("Clean.Markdown.WebApi")
    .Does(() =>
    {
        DotNetCoreRestore();
        DotNetCoreBuild("./RetailAnalytics.sln");
    });

Task("Publish.Markdown.WebApi")
    .Does(() =>
{

    DotNetCorePublish("./Markdown.WebApi/Markdown.WebApi.csproj");
});

Task("Clean.Markdown.WebApi")
    .Does(() =>
{
    CleanDirectory("./Markdown.WebApi/bin/");    
});

Task("Clean.Package.Directory")
    .Does(() =>
    {
        var directory = publish_dir;
        
        if (DirectoryExists(directory)) {
            DeleteDirectory(directory, true);

        }
        CreateDirectory(directory); 
    });


Task("Clean.Web.Test.Directory")
    .Does(() =>
    {
        var directory = "./RetailAnalytics.Web/testresults";
        
        if (DirectoryExists(directory)) {
            Information("Test Results Directory Exists, deleting...");
            DeleteDirectory(directory, true);
        }
    });    

Task("Clean.Web.Coverage.Directory")
    .Does(() =>
    {
        var directory = "./RetailAnalytics.Web/coverage";
        
        if (DirectoryExists(directory)) {
            Information("Coverage Directory exists, deleting...");
            DeleteDirectory(directory, true);
        }
    });

Task("Package.Web")
    .Does(() =>
{
    Zip("./RetailAnalytics.Web/dist", publish_dir + "/web.zip");
});

Task("Package.Web.Api")
    .Does(() =>
{
    Zip("./Markdown.WebApi/bin/Debug/netcoreapp1.0/publish/", publish_dir + "/web.api.zip");
});

Task("Package.Lambda.Function")
    .Does(() =>
{
    using(var process = StartAndReturnProcess("dotnet", new ProcessSettings { Arguments = "lambda package", WorkingDirectory = Directory("./Markdown.Function") })) {
        process.WaitForExit();
        if (process.GetExitCode() == 0) {
            CopyFile("./Markdown.Function/bin/Release/netcoreapp1.0/Markdown.Function.zip", publish_dir + "/retailax-markdown-lambda.zip");
        }
    }
});  


Task("Package.PostgresSql.App.Sql")
    .Does(() =>
{
    CreateDirectory(publish_dir + "/db/app");
    var appSqlFiles = GetFiles("./Markdown.Data.PostgresSql/app/*.sql");
    CopyFiles(appSqlFiles, publish_dir + "/db/app/");
    CopyFile("./Markdown.Data.PostgresSql/build.sh", publish_dir + "/db/build.sh");
    CopyFile("./Markdown.Data.PostgresSql/env_remote", publish_dir + "/db/env_remote");
    CopyFile("./Markdown.Data.PostgresSql/TestData.sql", publish_dir + "/db/TestData.sql");
    Zip(publish_dir + "/db/", publish_dir + "/db.zip");
    DeleteDirectory(publish_dir + "/db/", true);


});

Task("Package.Infrastructure")
    .Does(() =>
{ 
    Zip("./Infrastructure/", publish_dir + "/infrastructure.zip");
});

Task("Package.Bootstrap")
    .Does(() =>
{
    CopyFile("./build.ps1", publish_dir + "/build.ps1");
    CopyFile("./build.sh", publish_dir + "/build.sh");
    CopyFile("./deploy.cake", publish_dir + "/deploy.cake");
});

Task("Test.Web")
    .IsDependentOn("Clean.Web.Test.Directory")
    .Does(() =>
{
        var processBuilder = new ProcessArgumentBuilder();
        processBuilder.Append("test");
        processBuilder.Append("--code-coverage");
        processBuilder.Append("--single-run");
        processBuilder.Append("--browsers ChromeHeadless");
        using(var process = StartAndReturnProcess("ng", new ProcessSettings { Arguments = processBuilder.Render(), WorkingDirectory = Directory("./RetailAnalytics.Web"), RedirectStandardError = true })) {
            process.WaitForExit();
            if (process.GetExitCode() > 0) {

                // https://github.com/Microsoft/vsts-tasks/blob/master/docs/authoring/commands.md
                throw new Exception("##vso[task.logissue type=error] Web Test Failed");
            }
        }    
});

Task("Test.WebApi")
    .Does(() =>
{
    CleanDirectory("./Markdown.WebApi.Tests/TestResults");
    DotNetCoreTest("./Markdown.WebApi.Tests/Markdown.WebApi.Tests.csproj", new DotNetCoreTestSettings { ArgumentCustomization = args => args.Append("--logger trx;LogFileName=results.trx") });
});

Task("Test.Data")
    .Does(() =>
{
    CleanDirectory("./Markdown.Data.Tests/TestResults");    
    DotNetCoreTest("./Markdown.Data.Tests/Markdown.Data.Tests.csproj", new DotNetCoreTestSettings { ArgumentCustomization = args => args.Append("--logger trx;LogFileName=results.trx") });    
});

Task("Test.Service")
    .Does(() =>
{
    CleanDirectory("./Markdown.Service.Tests/TestResults");    
    DotNetCoreTest("./Markdown.Service.Tests/Markdown.Service.Tests.csproj", new DotNetCoreTestSettings { ArgumentCustomization = args => args.Append("--logger trx;LogFileName=results.trx") });    
});

Task("Default")
    .IsDependentOn("Build.Markdown.Data.PostgresSql")
    .IsDependentOn("Build.DotNetProjects")
    .IsDependentOn("Build.Web")
    .IsDependentOn("Test.Web")
    .IsDependentOn("Test.WebApi")
    .IsDependentOn("Test.Data")
    .IsDependentOn("Test.Service")
    .IsDependentOn("Publish.Markdown.WebApi")    
    .IsDependentOn("Clean.Package.Directory")
    .IsDependentOn("Package.Web")
    .IsDependentOn("Package.Lambda.Function")
    .IsDependentOn("Package.Web.Api")
    .IsDependentOn("Package.PostgresSql.App.Sql")
    .IsDependentOn("Package.Infrastructure")
    .IsDependentOn("Package.Bootstrap")
    .Does(() => {

    });

RunTarget(target);
