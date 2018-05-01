import boto3

dynamodb = boto3.resource('dynamodb')

def store_collection(collection):
    table = dynamodb.Table('game-chooser--collections')

    table.put_item(
       Item={
            'username': collection['username'],
            'last_name': collection['last_name'],
            'first_name': collection['first_name'],
            'bgg_user_id': collection['bgg_user_id']
        }
    )
