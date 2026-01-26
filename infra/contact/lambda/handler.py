import json
import os
import boto3

ses = boto3.client("ses", region_name=os.environ["AWS_REGION"])

TO_EMAIL = os.environ["TO_EMAIL"]

def handler(event, context):
    try:
        body = json.loads(event.get("body", "{}"))

        name = body.get("name")
        email = body.get("email")
        message = body.get("message")

        if not name or not email or not message:
            return response(400, {"error": "Missing fields"})

        ses.send_email(
            Source=TO_EMAIL,
            Destination={"ToAddresses": [TO_EMAIL]},
            Message={
                "Subject": {"Data": f"Kontakt ze strony: {name}"},
                "Body": {
                    "Text": {
                        "Data": f"Od: {name} <{email}>\n\n{message}"
                    }
                },
            },
            ReplyToAddresses=[email],
        )

        return response(200, {"ok": True})

    except Exception as e:
        print(e)
        return response(500, {"error": "Internal error"})


def response(status, body):
    return {
        "statusCode": status,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "https://witalijrapicki.cloud",
            "Access-Control-Allow-Methods": "POST,OPTIONS",
            "Access-Control-Allow-Headers": "Content-Type",
        },
        "body": json.dumps(body),
    }
