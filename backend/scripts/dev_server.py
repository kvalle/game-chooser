#!/usr/bin/env python

import json
import time
import sys
import os
import inspect

from flask import Flask, request, jsonify, _app_ctx_stack, Response
from flask_cors import cross_origin

# Find out where the script is located, then
# add app package to python path. Needed in order
# to be able to import the app modules.
cmd_folder = os.path.realpath(os.path.abspath(os.path.split(inspect.getfile(inspect.currentframe()))[0]))
backend_dir=os.path.realpath(cmd_folder+"/..")
if backend_dir not in sys.path:
	sys.path.insert(0, backend_dir)

import app.main

application = app.main.application


if __name__ == "__main__":
    application.debug = True
    application.run(host="0.0.0.0", port=7777, threaded=True)
