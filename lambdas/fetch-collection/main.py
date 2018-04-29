from datetime import datetime

import bgg
import database
import collection

def handler(event, context):
    username = event['username']

    collection = bgg.get_user(username)
    collection["created"] = datetime.utcnow().isoformat()
    collection["updated"] = datetime.utcnow().isoformat()
    collection["state"] = collection.STATE_WAITING

    database.store_collection(collection)

    return collection
