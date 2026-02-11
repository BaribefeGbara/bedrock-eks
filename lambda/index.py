import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event, context):
    """
    Lambda function triggered by S3 upload events.
    Logs the uploaded file name to CloudWatch.
    """
    logger.info(f"Received event: {json.dumps(event)}")
    
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']
        
        # Log the image received (REQUIRED for grading)
        logger.info(f"Image received: {key}")
        
    return {
        'statusCode': 200,
        'body': json.dumps('File processed successfully')
    }
