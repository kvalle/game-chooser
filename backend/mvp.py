#!/usr/bin/env python
# encoding: utf-8

import time
import sys
import requests
import xmltodict
import pprint 
from pprint import pprint as pp

name = sys.argv[1]

print "> Fetching BGG data for " + name + "…"

r = requests.get('https://www.boardgamegeek.com/xmlapi2/user?name=' + name)

data = xmltodict.parse(r.text)

firstname = data["user"]["firstname"]["@value"]
lastname = data["user"]["lastname"]["@value"]

print "HI, " + firstname + " " + lastname

print "> Fetching games…"

retries = 0
url = 'https://www.boardgamegeek.com/xmlapi2/collection?username=' + name + '&own=1&excludesubtype=boardgameexpansion'

while retries < 4:
	r = requests.get(url)
	if r.status_code == 202:
		retries += 1
		time.sleep(0.2)
		print "> Retry " + str(retries)
	else:
		break

data = xmltodict.parse(r.text)


games = [{
		"id": game["@objectid"],
		"name": game["name"]["#text"], 
		"year": game["yearpublished"],
		"thumbnail_url": game["thumbnail"],
		"image_url": game["image"]  
	} for game in data["items"]["item"]]

pp(games)
print str(len(games)) + " games"
