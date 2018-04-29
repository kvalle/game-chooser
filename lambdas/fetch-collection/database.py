import boto3

dynamodb = boto3.resource('dynamodb')

def store_user(user):
    table = dynamodb.Table('game-chooser--collections')
    table.put_item(
       Item={
            'username': user['username'],
            'last_name': user['last_name'],
            'first_name': user['first_name'],
            'bgg_user_id': user['bgg_user_id']
        }
    )
