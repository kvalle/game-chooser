import firebase_admin
from firebase_admin import credentials
from firebase_admin import db

import config

def connect():
	cred = credentials.Certificate('firebase-serviceAccountKey.json')
	firebase_admin.initialize_app(cred, config.firebase)

def get_game(game_id):
	return db.reference('games').child(game_id).get()

def save_game(game_id, game):
	games_ref = db.reference('games')
	games_ref.child(game_id).set(game)

def save_games(games):
	db.reference('games').set(games)

def save_poll(game_ids):
	polls_ref = db.reference('polls')
	polls_ref.push(game_ids)

if __name__ == "__main__":
	connect()

	save_game("68448", {
	    "image_url": "https://cf.geekdo-images.com/images/pic860217.jpg",
	    "year": "2010",
	    "thumbnail_url": "https://cf.geekdo-images.com/images/pic860217_t.jpg",
	    "id": "68448",
	    "title": "7 Wonders"
	})

	print get_game("68448")
