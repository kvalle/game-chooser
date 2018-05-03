import boto3

dynamodb = boto3.resource('dynamodb', region_name='eu-central-1')

def store_collection(collection):
    table = dynamodb.Table('game-chooser--collections')
    table.put_item(Item=collection)


def collection_from_dynamo_event(event):
    return {
        "username": event["username"]["S"],
        "updated": event["updated"]["S"],
        "last_name": event["last_name"]["S"],
        "created": event["created"]["S"],
        "first_name": event["first_name"]["S"],
        "state": event["state"]["S"],
        "bgg_user_id": event["bgg_user_id"]["S"]
    }
