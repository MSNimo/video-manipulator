# Video Manipulation Program
# Takes in Inputs: URL, KEYWORD, ACTION
# Returns: VIDEO, from URL, where ACTION is performed at every KEYWORD

import os
from flask import Flask
from flask import request
from flask import jsonify
from flask import render_template
import json
import datetime

app = Flask(__name__)

app.route('/', methods=['GET', 'POST'])
def index():
	render_template('index.html')
	if request.method == 'POST':
		url = request.form['link']
		key = request.form['keyword']
	        act = request.form['action']
	return render_template('processing.html')	

if __name__ == '__main__':
        app.debug = True
        port = int(os.environ.get('PORT',5000))
        app.run(host='0.0.0.0', port=port)
	#app.run(debug=True)