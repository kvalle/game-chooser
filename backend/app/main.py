#!/usr/bin/env python

import json
import time
import sys

from flask import Flask, request, jsonify, _app_ctx_stack, Response
from flask_cors import cross_origin

import bgg
import firebase

application = Flask("Game Chooser")
firebase.connect()

@application.route("/ping", methods=['GET'])
def ping():
    return "pong"


@application.route("/user/<username>", methods=['GET'])
@cross_origin(headers=['Content-Type', 'Accept'])
def get_user(username):
    user = bgg.get_user(username)
    json_data = json.dumps(user)
    return Response(response=json_data, status=200, mimetype="application/json")


@application.route("/user/<username>/games", methods=['GET'])
@cross_origin(headers=['Content-Type', 'Accept'])
def get_user_games(username):
    games = bgg.get_games(username)

    db_games = { game["id"]: game for game in games }
    firebase.save_games(db_games)

    json_data = json.dumps(games)
    return Response(response=json_data, status=200, mimetype="application/json")


@application.route("/poll", methods=['POST'])
@cross_origin(headers=['Content-Type', 'Accept'])
def post_poll():
    game_ids = request.get_json()
    if game_ids is None:
        return bad_request()

    poll_id = firebase.save_poll(game_ids)

    json_data = json.dumps({ "id": poll_id })
    return Response(response=json_data, status=200, mimetype="application/json")


@application.route("/poll/<poll_id>", methods=['GET'])
@cross_origin(headers=['Content-Type', 'Accept'])
def get_poll(poll_id):
    fb_poll = firebase.get_poll(poll_id)

    poll = {
        "id": poll_id,
        "games": { game_id: firebase.get_game(game_id)
                    for game_id in fb_poll["game_ids"]},
        "votes": fb_poll["votes"] if "votes" in fb_poll else {}
    }

    json_data = json.dumps(poll)
    return Response(response=json_data, status=200, mimetype="application/json")


@application.route("/poll/<poll_id>/vote", methods=['POST'])
@cross_origin(headers=['Content-Type', 'Accept'])
def vote_poll(poll_id):
    vote = request.get_json()
    if vote is None:
        return bad_request()

    firebase.vote_poll(poll_id, vote["name"], vote["game_ids"])

    return Response(response="", status=200, mimetype="text/plain")


def bad_request():
    resp = jsonify({'code': 'bad_request',
                    'description': 'expected json'})
    resp.status_code = 400
    return resp
