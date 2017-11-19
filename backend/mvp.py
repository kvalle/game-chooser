#!/usr/bin/env python
# encoding: utf-8

import time
import sys
import requests
import xmltodict
import pprint 
from pprint import pprint as pp

import app.bgg as bgg

name = sys.argv[1]
user = bgg.get_user(name)
games = bgg.get_games(name)

pp(games)
print str(len(games)) + " games"
