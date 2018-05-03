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

def collection_worker(event, context):
    rows = [r["dynamodb"]["NewImage"] for r in event["Records"]]
    rows = filter(lambda r: r["state"]["S"] == STATE_WAITING, rows)

    result = {
        "updated": 0
    }

    for row in rows:
        collection = database.collection_from_dynamo_event(row)
        collection["state"] = STATE_IDLE
        database.store_collection(collection)
        result["updated"] += 1

    print result

def ping(event, context):
    return {
        "statusCode": 200,
        "body": "pong"
    }
