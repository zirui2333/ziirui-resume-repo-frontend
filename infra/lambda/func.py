import json
import boto3


 #connect to table
dynamodb = boto3.resource("dynamodb")
table_name = "ziirui-resume-db"
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
    
    
    
    
    # TODO implement
    # return views
    # return {
    #     "views" : views
    # }
    
    return views