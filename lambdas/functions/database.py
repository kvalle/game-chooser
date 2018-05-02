import boto3

dynamodb = boto3.resource('dynamodb', region_name='eu-central-1')

def store_collection(collection):
    table = dynamodb.Table('game-chooser--collections')
    table.put_item(Item=collection)
