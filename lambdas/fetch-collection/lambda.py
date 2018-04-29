import requests
import xmltodict

def get_user(name):
	r = requests.get('https://www.boardgamegeek.com/xmlapi2/user?name=' + name)
	data = xmltodict.parse(r.text)

	return {
		"id": data["user"]["@id"],
		"username": name,
		"firstname": data["user"]["firstname"]["@value"],
		"lastname": data["user"]["lastname"]["@value"]
	}
def handler(event, context):
    user = get_user(event['username'])
    return user
