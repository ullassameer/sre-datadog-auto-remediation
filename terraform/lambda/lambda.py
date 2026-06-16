import boto3
import os

ssm = boto3.client("ssm")

INSTANCE_ID = os.environ["INSTANCE_ID"]

def lambda_handler(event, context):

    response = ssm.send_command(

        InstanceIds=[INSTANCE_ID],

        DocumentName="AWS-RunShellScript",

        Parameters={

            "commands":[

                """
mkdir -p /tmp/sre

aws s3 cp \
s3://BUCKET/scripts/diagnostics.sh \
/tmp/

chmod +x \
/tmp/diagnostics.sh

sudo /tmp/diagnostics.sh
"""

            ]

        }

    )

    return response