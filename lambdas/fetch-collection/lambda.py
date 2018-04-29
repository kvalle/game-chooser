def handler(event, context):
    message = 'val1 is {} and val2 is {}'.format(event['val1'],
                                                 event['val2'])

    print("Dummy lambda says: " + message)
    return {
        'message' : message
    }
