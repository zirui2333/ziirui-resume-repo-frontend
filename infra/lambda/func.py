import json
import boto3


 #connect to table
dynamodb = boto3.resource("dynamodb")
table_name = "dynamodb_table_for_resume"
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    id = "1"
    response = table.get_item(Key={
        'id':id
    })

    
    if "Item" in response:
        views = response["Item"]["views"]
        views += 1
        table.put_item(Item = {
            "id" : id,
            "views" : views
        })
        
    else:
        views = 1
        table.put_item(Item = {
            "id" : id,
            "views" : views
        })
    
    return_format = {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json/update_counter',
                'Access-Control-Allow-Origin': ('*'),  # Allow CORS
                'Access-Control-Allow-Methods': '*',
                'Access-Control-Allow-Headers': 'Content-Type'
            },
            'body': json.dumps({
                'message': 'success',
                'count': int(views)
            })
        }
        


    return return_format