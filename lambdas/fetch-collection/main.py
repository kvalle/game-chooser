from datetime import datetime

import bgg
import database
import collection

def handler(event, context):
    username = event['username']

    user = bgg.get_user(username)
    user["created"] = datetime.utcnow().isoformat()
    user["updated"] = datetime.utcnow().isoformat()
    user["state"] = collection.STATE_WAITING

    database.store_user(user)

    return user
