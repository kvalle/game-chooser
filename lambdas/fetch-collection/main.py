from datetime import datetime

import bgg
import database

# Collection states
STATE_IDLE = "IDLE"        # request for game list run, need to wait for BGG
STATE_WAITING = "WAITING"  # request for games given enough time, needs checking
STATE_LOADED = "LOADED"    # game list loaded successfully
STATE_FAILED = "FAILED"    # failed to load game list

def handler(event, context):
    username = event['username']

    collection = bgg.get_user(username)
    collection["created"] = datetime.utcnow().isoformat()
    collection["updated"] = datetime.utcnow().isoformat()
    collection["state"] = STATE_WAITING

    database.store_collection(collection)

    return collection
