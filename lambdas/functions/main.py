from datetime import datetime
import json

import bgg
import database

# Collection states
STATE_IDLE = "IDLE"        # request for game list run, need to wait for BGG
STATE_WAITING = "WAITING"  # request for games given enough time, needs checking
STATE_LOADED = "LOADED"    # game list loaded successfully
STATE_FAILED = "FAILED"    # failed to load game list

def fetch_collection(event, context):
    username = event["pathParameters"]["username"]

    collection = bgg.get_user(username)
    collection["created"] = datetime.utcnow().isoformat()
    collection["updated"] = datetime.utcnow().isoformat()
    collection["state"] = STATE_WAITING

    database.store_collection(collection)

    return {
        "statusCode": 201,
        "body": json.dumps(collection)
    }


def ping(event, context):
    return {
        "statusCode": 200,
        "body": "pong"
    }
