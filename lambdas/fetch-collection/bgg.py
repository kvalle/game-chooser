import requests
import xmltodict
import time

def get_games(user_name, max_retries=50):
	url = 'https://www.boardgamegeek.com/xmlapi2/collection?username=' + user_name + '&own=1&excludesubtype=boardgameexpansion'

	retries = 0
	while retries < max_retries:
		r = requests.get(url)
		if r.status_code == 202:
			retries += 1
			time.sleep(0.2)
		elif r.status_code != 200:
			print "BAD RESPONSE"
			print r.text
			break
		else:
			break

	data = xmltodict.parse(r.text)

	return [{
		"id": game["@objectid"],
		"title": game["name"]["#text"],
		"year": game["yearpublished"] if "yearpublished" in game else None,
		"thumbnail_url": game["thumbnail"],
		"image_url": game["image"]
	} for game in data["items"]["item"]]

def get_user(name):
    r = requests.get('https://www.boardgamegeek.com/xmlapi2/user?name=' + name)
    data = xmltodict.parse(r.text)

    return {
        "bgg_user_id": data["user"]["@id"],
        "username": name,
        "first_name": data["user"]["firstname"]["@value"],
        "last_name": data["user"]["lastname"]["@value"]
    }
