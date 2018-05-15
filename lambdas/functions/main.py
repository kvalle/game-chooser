from datetime import datetime
import json
import traceback

import bgg
import database

def fetch_collection(event, context):
    username = event["pathParameters"]["username"]

    collection = bgg.get_user(username)
    collection["created"] = datetime.utcnow().isoformat()
    collection["updated"] = datetime.utcnow().isoformat()

    attempts=10
    while attempts > 0:
        try:
            print "INFO: FETCHING %s" % username
            games_response = bgg.get_games(username)

            if games_response["status"] == 200:
                collection["games"] = games_response["games"]
                database.store_collection(collection)
                return response(collection, 201)

            elif games_response["status"] == 202:
                time.sleep(0.5)
                print "INFO: Waiting for data..."
                attempts -= 1
                continue

            else:
                print "ERROR: %s" % games_response["error"]
                body = { "message": "problem fetching data from BGG" }
                return response(body, 503)

        except Exception as e:
            print "ERROR:"
            traceback.print_exc()
            body = { "message": "encountered an error while processing request" }
            return response(body, 500)


def ping(event, context):
    return {
        "statusCode": 200,
        "body": "pong"
    }

def response(body, code=200):
    return {
        "statusCode": code,
        "body": json.dumps(body)
    }
