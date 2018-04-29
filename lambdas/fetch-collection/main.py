import requests
import xmltodict
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

def get_user(name):
    r = requests.get('https://www.boardgamegeek.com/xmlapi2/user?name=' + name)
    data = xmltodict.parse(r.text)

    return {
        "bgg_user_id": data["user"]["@id"],
        "username": name,
        "first_name": data["user"]["firstname"]["@value"],
        "last_name": data["user"]["lastname"]["@value"]
    }

def handler(event, context):
    user = get_user(event['username'])
    store_user(user)
    return user
