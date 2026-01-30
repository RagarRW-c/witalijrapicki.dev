import json

def handler(event, context):
    print("EVENT:", json.dumps(event))

    # CORS preflight
    if event.get("httpMethod") == "OPTIONS":
        return {
            "statusCode": 200,
            "headers": {
                "Access-Control-Allow-Origin": "https://witalijrapicki.cloud",
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Methods": "POST,OPTIONS"
            },
            "body": ""
        }

    try:
        body = json.loads(event.get("body", "{}"))

        name = body.get("name")
        email = body.get("email")
        message = body.get("message")

        if not name or not email or not message:
            return {
                "statusCode": 400,
                "headers": {
                    "Access-Control-Allow-Origin": "https://witalijrapicki.cloud"
                },
                "body": json.dumps({"error": "Invalid input"})
            }

        # TODO: tu później SES / zapis
        print("CONTACT:", name, email, message)

        return {
            "statusCode": 200,
            "headers": {
                "Access-Control-Allow-Origin": "https://witalijrapicki.cloud"
            },
            "body": json.dumps({"ok": True})
        }

    except Exception as e:
        print("ERROR:", str(e))

        return {
            "statusCode": 500,
            "headers": {
                "Access-Control-Allow-Origin": "https://witalijrapicki.cloud"
            },
            "body": json.dumps({"error": "Internal Server Error"})
        }
