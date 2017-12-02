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
	new_poll_ref = polls_ref.push(game_ids)
	return new_poll_ref.key

def get_poll(poll_id):
	return db.reference('polls').child(poll_id).get()


if __name__ == "__main__":
	connect()

	dummy_ref = db.reference('dummy')
	new_ref = dummy_ref.push({"foo": "baz"})

	print new_ref.key
	print new_ref.get()
