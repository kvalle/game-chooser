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

    json_data = json.dumps({
        "id": poll_id
    })
    print json_data
    return Response(response=json_data, status=200, mimetype="application/json")


def bad_request():
    resp = jsonify({'code': 'bad_request',
                    'description': 'expected json'})
    resp.status_code = 400
    return resp
