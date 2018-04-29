import database
import bgg

def handler(event, context):
    username = event['username']

    user = bgg.get_user(username)
    games = bgg.get_games(username)

    database.store_user(user)

    user["games"] = games
    
    return user
