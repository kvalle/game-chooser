import requests
import xmltodict
import time

def get_user(name):
	r = requests.get('https://www.boardgamegeek.com/xmlapi2/user?name=' + name)
	data = xmltodict.parse(r.text)

	return {
		"id": data["user"]["@id"],
		"username": name,
		"firstname": data["user"]["firstname"]["@value"],
		"lastname": data["user"]["lastname"]["@value"]
	}

def get_games(user_name, max_retries=4):
	url = 'https://www.boardgamegeek.com/xmlapi2/collection?username=' + user_name + '&own=1&excludesubtype=boardgameexpansion'

	retries = 0
	while retries < max_retries:
		r = requests.get(url)
		if r.status_code == 202:
			retries += 1
			time.sleep(0.2)
		else:
			break

	data = xmltodict.parse(r.text)

	return [{
		"id": game["@objectid"],
		"name": game["name"]["#text"], 
		"year": game["yearpublished"],
		"thumbnail_url": game["thumbnail"],
		"image_url": game["image"]  
	} for game in data["items"]["item"]]
