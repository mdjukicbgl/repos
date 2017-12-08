{
		"objects": [
				    {
				      "failureAndRerunMode": "CASCADE",
				      "resourceRole": "DataPipelineDefaultResourceRole",
				      "role": "DataPipelineDefaultRole",
				      "pipelineLogUri": "s3://mdj-bucket-logs/logs/",
				      "scheduleType": "ONDEMAND",
				      "name": "Default",
				      "id": "Default"
				    },
				    {
				      "name": "CliActivity",
				      "id": "CliActivity",
				      "runsOn": {
				        "ref": "Ec2Instance"
				      },
				      "type": "ShellCommandActivity",
				      "command": "(sudo yum -y update aws-cli) && (#{myAWSCLICmd})"
				    },
				    {
				      "instanceType": "t1.micro",
				      "name": "Ec2Instance",
				      "id": "Ec2Instance",
				      "type": "Ec2Resource",
				      "terminateAfter": "50 Minutes"
				    }
				  ],
		"parameters": [
		  			{
		  			  "watermark": "aws [options] <command> <subcommand> [parameters]",
		  			  "description": "AWS CLI command",
		  			  "id": "myAWSCLICmd",
		  			  "type": "String"
		  			}
		],
		"values": {
				    "myAWSCLICmd": "aws s3 ls s3://mdj-bucket-001/"
					}
}