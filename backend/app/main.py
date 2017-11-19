#!/usr/bin/env python

import json
import time
import sys

from flask import Flask, request, jsonify, _app_ctx_stack, Response
from flask_cors import cross_origin

import bgg


application = Flask("Game Chooser")


@application.route("/ping", methods=['GET'])
def ping():
    return "pong"


@application.route("/user/<username>", methods=['GET'])
def get_user(username):
    user = bgg.get_user(username)
    data = json.dumps(user)
    return Response(response=data, status=200, mimetype="application/json")


@application.route("/user/<username>/games", methods=['GET'])
def get_user_games(username):
    games = bgg.get_games(username)
    data = json.dumps(games)
    return Response(response=data, status=200, mimetype="application/json")
