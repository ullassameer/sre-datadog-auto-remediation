import boto3
import os

ssm = boto3.client("ssm")

INSTANCE=os.environ["INSTANCE_ID"]

BUCKET=os.environ["BUCKET"]


def lambda_handler(event, context):

    commands = [

f"""
aws s3 cp \
s3://{BUCKET}/scripts/diagnostics.sh \
/tmp/diagnostics.sh

chmod +x \
/tmp/diagnostics.sh

sudo /tmp/diagnostics.sh
"""

]

    response = ssm.send_command(

        InstanceIds=[INSTANCE],

        DocumentName="AWS-RunShellScript",

        Parameters={

            "commands": commands

        }

    )

    return {

        "status": "started",

        "command_id":
response["Command"]["CommandId"]

    }