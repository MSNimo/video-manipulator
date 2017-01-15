# Video Manipulation Program
# Takes in Inputs: URL, KEYWORD, ACTION
# Returns: VIDEO, from URL, where ACTION is performed at every KEYWORD

import os
from flask import Flask
from flask import request
from flask import jsonify
from flask import render_template
import pafy
import json
import datetime
import webbrowser

 
app = Flask(__name__) 

error = 'none'
@app.route('/', methods=['GET', 'POST'])
def index():
        render_template('index.html')
	if request.method == 'POST':
		url = request.form['link']
		key = request.form['keyword']
	        act = request.form['action']
	        return editor (url, key, act)
	return render_template('index.html')	
  
def editor(url, key, act):

    website = 'youtube.com'
    if website in url:
        video = pafy.new(url)
        streams = video.streams
        s_num = len(streams)
        s_choice = s_num//2
        video_file = streams[s_choice].download#(filepath = "")
        return video_file
        #return streams[s_choice]
    else:
        error = "youtube link not provided"
        return render_template('index.html', error = error)
        
    '''  
    i = 0
    while (i < 100000000):
        i= i + 1 
    return (key+act)
   '''
    
if __name__ == '__main__':
        app.debug = True
        port = int(os.environ.get('PORT',5000))
        app.run(host='0.0.0.0', port=port)
	#app.run(debug=True)