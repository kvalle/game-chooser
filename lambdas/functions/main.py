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
        "completed": 0,
        "still_waiting": 0,
        "failed": 0
    }

    for row in rows:
        collection = database.collection_from_dynamo_event(row)

        games_response = bgg.get_games(collection["username"])
        if games_response["status"] == 200:
            collection["state"] = STATE_LOADED
            collection["games"] = games_response["games"]
            result["completed"] += 1
        elif games_response["status"] == 202:
            collection["state"] = STATE_IDLE
            result["still_waiting"] += 1
        else:
            collection["state"] = STATE_FAILED
            result["failed"] += 1

        database.store_collection(collection)

    print result

def ping(event, context):
    return {
        "statusCode": 200,
        "body": "pong"
    }
