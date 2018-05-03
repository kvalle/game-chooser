import requests
import xmltodict
import time

def get_games(username):
	url = 'https://www.boardgamegeek.com/xmlapi2/collection?username=' + username + '&own=1&excludesubtype=boardgameexpansion'
	r = requests.get(url)

	if r.status_code == 202:
		return {
			"status": 202
		}
	elif r.status_code == 200:
		data = xmltodict.parse(r.text)
		games = [{
			"id": game["@objectid"],
			"title": game["name"]["#text"],
			"year": game["yearpublished"] if "yearpublished" in game else None,
			"thumbnail_url": game["thumbnail"],
			"image_url": game["image"]
		} for game in data["items"]["item"]]

		return {
			"status": 200,
			"games": games
		}
	else:
		return {
			"status": r.status_code,
			"error": r.text
		}


def get_user(name):
    r = requests.get('https://www.boardgamegeek.com/xmlapi2/user?name=' + name)
    data = xmltodict.parse(r.text)

    return {
        "bgg_user_id": data["user"]["@id"],
        "username": name,
        "first_name": data["user"]["firstname"]["@value"],
        "last_name": data["user"]["lastname"]["@value"]
    }
