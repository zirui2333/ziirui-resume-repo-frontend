import json
import boto3


 #connect to table
dynamodb = boto3.resource("dynamodb")
table_name = "dynamodb_table_for_resume"
table = dynamodb.Table(table_name)

def lambda_handler(event, context):

    response = table.get_item(Key={
        'id':'1'
    })


    if "Item" in response:
        views = response["Item"]["views"]
        views += 1
        table.put_item(Item = {
            "id" : "1",
            "views" : views
        })
    return_format = {
            'status' : 200,
            'body': json.dumps({
                'message' : 'success',
                'count' : str(views)
            })
        }
    return return_format