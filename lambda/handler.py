def handler(event, context):
    record = event["Records"][0]
    key = record["s3"]["object"]["key"]
    print(f"Image received: {key}")
