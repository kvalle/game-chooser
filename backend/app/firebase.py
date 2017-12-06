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
	# FIXME: should add, not override
	db.reference('games').set(games)


def save_poll(game_ids):
	"""Create a new poll from list of game IDs"""

	polls_ref = db.reference("polls")
	new_poll_ref = polls_ref.push()
	new_poll_ref.child("game_ids").set(game_ids)
	new_poll_ref.child("votes").set([])

	return new_poll_ref.key


def vote_poll(poll_id, name, game_ids):
	polls_ref = db.reference("polls")
	polls_ref.child(poll_id).child("votes").child(name).set(game_ids)


def get_poll(poll_id):
	return db.reference('polls').child(poll_id).get()


if __name__ == "__main__":
	connect()
	vote_poll("-L-NrWR2MFz9mrBkty9W", "tine", ["50"])

	print get_poll("-L-NrWR2MFz9mrBkty9W")
