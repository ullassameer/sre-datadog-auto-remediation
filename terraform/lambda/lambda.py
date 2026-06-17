def lambda_handler(event, context):

    usage = float(event.get("value", 0))

    if usage < 0.70:

        return {
            "status": "skipped",
            "reason": "disk below threshold"
        }

    commands = [

f"""
rm -f /tmp/diagnostics.sh

aws s3 cp \
s3://{BUCKET}/scripts/diagnostics.sh \
/tmp/diagnostics.sh

chmod +x \
/tmp/diagnostics.sh

cat /tmp/diagnostics.sh | tail -20

sudo /tmp/diagnostics.sh {BUCKET}
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
        "usage": usage,
        "command_id":
response["Command"]["CommandId"]
    }