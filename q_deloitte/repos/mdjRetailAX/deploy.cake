#addin "Cake.FileHelpers"
#addin "Cake.AWS.S3"
#addin "Cake.Terraform"
#addin "Cake.SqlTools"

var target = Argument("target", "Default");
var env = Argument("environment", "dev");
var deploy_dir = Argument("deploy_dir", MakeAbsolute(Directory("./_deploy")).FullPath);

var publish_dir = Argument("publish_dir", MakeAbsolute(Directory("./_publish")).FullPath);
var private_key_file = Argument("private_key_file", "pf-retailax-dev.pem");
var website_s3_bucket = Argument("website_s3_bucket", "retailax-web-dev");

var cloud_watch_aws_key_id = Argument("cloud_watch_aws_key", "AKIAJ3MYTPWJKGYJ4M7Q");
var cloud_watch_aws_secret_key = Argument("cloud_watch_aws_secret_key", "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");

var cors_origin = Argument("cors_origin", "https://dev.deloitteretailanalytics.deloittecloud.co.uk");


var dest_host = Argument("DEST_HOST", "pf-dev-02.c6fmhp4adr4a.eu-west-1.rds.amazonaws.com");
var dest_port = Argument("DEST_PORT", "5432");
var dest_database = Argument("DEST_DATABASE", "app");
var dest_default_database = Argument("DEST_DEFAULTDATABASE", "master");
var dest_user = Argument("DEST_USER", "testdb");
var dest_pass = Argument("DEST_PASS", "0fbf52bf");
var dest_readuser = Argument("DEST_READUSER", "markdown");

var dw_host = Argument("DW_HOST", "mkd-v4-dev-2.cjdnl11hxvdw.eu-west-1.redshift.amazonaws.com");
var dw_port = Argument("DW_PORT", "5439");
var dw_database = Argument("DW_DATABASE", "markdown");
var dw_user = Argument("DW_USER", "mkdwn");
var dw_pass = Argument("DW_PASS", "378dhsdkdnDsj.mDs");

var tf_output = new Dictionary<string, string>();

Task("Infra.Init")
    .Does(() =>
{
    var settings = new TerraformInitSettings {
        WorkingDirectory = deploy_dir + "/infrastructure/" + env
    };
    TerraformInit(settings);    
});

Task("Infra.Plan")
    .IsDependentOn("Infra.Init")
    .Does(() =>
{
    var settings = new TerraformPlanSettings {
        WorkingDirectory = deploy_dir + "/infrastructure/" + env    
    };
    TerraformPlan(settings);    
});

Task("Infra.Destroy")
    .Does(() =>
{
    var settings = new TerraformDestroySettings {
        WorkingDirectory = deploy_dir + "/infrastructure/" + env
    };
    TerraformDestroy(settings);
});

Task("Infra.Apply")
    .IsDependentOn("Infra.Init")
    .Does(() =>
{
    var settings = new TerraformApplySettings {
        WorkingDirectory = deploy_dir + "/infrastructure/" + env
    };
    TerraformApply(settings);    

    Information("Waiting 15 secs for AWS to catch up...");
    System.Threading.Thread.Sleep(15000);

});

Task("Infra.Variables")
    .Does(() =>
{
    IEnumerable<string> stdout = new List<string>();
    var processBuilder = new ProcessArgumentBuilder();
    processBuilder.Append("output");

    var exitCodeWithArgument = StartProcess("terraform", new ProcessSettings { Arguments = processBuilder.Render(), WorkingDirectory = Directory(deploy_dir + "/infrastructure/" + env), RedirectStandardOutput = true }, out stdout);

    foreach(var line in stdout) {
        var keyValue = line.Split('=');
        tf_output.Add(keyValue[0].Trim(), keyValue[1].Trim());
        Information("key:" + keyValue[0].Trim() + ", val:" + keyValue[1].Trim());
    } 
});

Task("Web.Deploy")
    .Does(() =>
{
    CleanDirectory(deploy_dir + "/web");
    CreateDirectory(deploy_dir + "/web");
    // Check if file exists
    if (FileExists(publish_dir + "/web.zip")) {
        Unzip(publish_dir + "/web.zip", deploy_dir + "/web");
    }

    var processBuilder = new ProcessArgumentBuilder();
    processBuilder.Append("s3");
    processBuilder.Append("sync");
    processBuilder.Append(".");
    processBuilder.Append("s3://retailax-web-" + env);
    processBuilder.Append("--delete");

    using(var process = StartAndReturnProcess("aws", new ProcessSettings { Arguments = processBuilder.Render(), WorkingDirectory = Directory(deploy_dir + "/web") })) {
        process.WaitForExit();
    }
    // Modify environment variables
    // Will need to move towards having config file in assets directory, can't do build time compile

    // Upload it

});

Task("Lambda.Deploy")
    .Does(() =>
{
    CopyFile(publish_dir + "/retailax-markdown-lambda.zip", deploy_dir + "/retailax-markdown-lambda.zip");
    CopyFile(deploy_dir + "/retailax-markdown-lambda.zip", deploy_dir + "/infrastructure/" + env + "/retailax-markdown-lambda.zip");
});

Task("WebApi.Deploy")
    .Does(() =>
{
    CleanDirectory(deploy_dir + "/webapi");
    CreateDirectory(deploy_dir + "/webapi");

    if (FileExists(publish_dir + "/web.api.zip")) {
        Unzip(publish_dir + "/web.api.zip", deploy_dir + "/webapi");
    } else {
        throw new Exception("Could not find web api artifact");
    }

    //CopyFile("./Infrastructure/" + env + "/web-api-host", "./Infrastructure/provision/api/web-api-host");

    var app_db_connection_string = String.Format("Host={0};Username={1};Password={2};Database={3};Pooling=true;CommandTimeout=60;", 
        tf_output["app_db_address"],
        tf_output["app_db_username"],
        tf_output["app_db_password"],
        tf_output["app_db_database"]
    );

    /*
    var model_db_connection_string = String.Format("Host={0};Username={1};Password={2};Database={3};Pooling=true;CommandTimeout=60;", 
        tf_output["model_db_address"],
        tf_output["model_db_username"],
        tf_output["model_db_password"],
        dest_database
    );  */

    var processBuilder = new ProcessArgumentBuilder();
    processBuilder.Append("playbook.yml");
    processBuilder.Append("-i \"" + tf_output["api_private_ip"] + ",\"");
    processBuilder.Append("--private-key=" + private_key_file);
    processBuilder.Append("-verbose");
    processBuilder.Append("--connection=ssh");
    processBuilder.Append("--user=ubuntu");
    //processBuilder.Append("-vvvv");
    processBuilder.Append("--extra-vars \"app_db_connection_string=" + app_db_connection_string + "\"");
    processBuilder.Append("--extra-vars \"model_db_connection_string=" + app_db_connection_string + "\"");
    processBuilder.Append("--extra-vars \"cloud_watch_aws_key_id=" + cloud_watch_aws_key_id +"\"");
    processBuilder.Append("--extra-vars \"cloud_watch_aws_secret_key="+ cloud_watch_aws_secret_key +"\"");
    //processBuilder.Append("--extra-vars \"cors_origin=http://" + tf_output["website_endpoint"] + "\"");
    processBuilder.Append("--extra-vars \"cors_origin=" + cors_origin +"\"");
    processBuilder.Append("--extra-vars \"lambda_function_name=" + tf_output["model_processor_lambda_function_name"] + "\"");
    processBuilder.Append("--extra-vars \"deploy_dir=" + deploy_dir + "\"");


    using(var process = StartAndReturnProcess("ansible-playbook", new ProcessSettings { 
            Arguments = processBuilder.Render(), 
            WorkingDirectory = Directory(deploy_dir + "/infrastructure/provision/api"), 
            EnvironmentVariables = new Dictionary<string, string> {
                { "ANSIBLE_HOST_KEY_CHECKING", "False" }
            }})) {

        process.WaitForExit();

        if (process.GetExitCode() > 0) {
            throw new Exception("##vso[task.logissue type=error] Web Api Provision Failed");
        }
    }    
});



Task("Db.Deploy")
    .Does(() =>
{
    CleanDirectory(deploy_dir +  "/db");
    Unzip(publish_dir + "/db.zip", deploy_dir + "/db");
    //CopyDirectory(publish_dir + "/db", deploy_dir + "/db");

    var processBuilder = new ProcessArgumentBuilder();
    processBuilder.Append("build.sh");

    using(var process = StartAndReturnProcess("/bin/bash", new ProcessSettings { 
            Arguments = processBuilder.Render(),        
            WorkingDirectory = Directory(deploy_dir + "/db"), 
            EnvironmentVariables = new Dictionary<string, string> {
                { "DEST_HOST",  tf_output["app_db_address"] },
                { "DEST_PORT",  tf_output["app_db_port"] },
                { "DEST_DATABASE", tf_output["app_db_database"] },
                { "DEST_DEFAULTDATABASE", tf_output["app_db_default_database"] },
                { "DEST_USER", tf_output["app_db_username"] },
                { "DEST_PASS", tf_output["app_db_password"] },
                { "DEST_READUSER", dest_readuser },
                { "DEST_READPASS", "Mark-down14" },
                { "DW_USER", dw_user },
                { "DW_HOST", dw_host },
                { "DW_PORT", dw_port },
                { "DW_DATABASE", dw_database },
                { "DW_PASS", dw_pass }

            }})) {

        process.WaitForExit();

        if (process.GetExitCode() > 0) {
            throw new Exception("##vso[task.logissue type=error] Db Deploy Failed");
        }        
    }  
});

Task("Unpack.Artifact")
    .Does(() =>
{
    if (DirectoryExists(deploy_dir)) {
        CleanDirectory(deploy_dir);
        //DeleteDirectory(deploy_dir + "/infrastructure", true);
    }


    Unzip(publish_dir + "/infrastructure.zip", deploy_dir + "/infrastructure");
    Unzip(publish_dir + "/db.zip", deploy_dir + "/db");
});

Task("Bootstrap.Information")
    .Does(() =>
{
    Information("Deploy Directory: " + deploy_dir);
    Information("Publish Directory: " + publish_dir);    
});

Task("Default")
    .IsDependentOn("Bootstrap.Information")
    .IsDependentOn("Unpack.Artifact")
    .IsDependentOn("Lambda.Deploy")   
    .IsDependentOn("Infra.Apply")
    .IsDependentOn("Infra.Variables")
    .IsDependentOn("Web.Deploy")
    .IsDependentOn("WebApi.Deploy")
    .IsDependentOn("Db.Deploy")
    .Does(() => {

    });

RunTarget(target);