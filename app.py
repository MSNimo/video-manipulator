# Video Manipulation Program
# Takes in Inputs: URL, KEYWORD, ACTION
# Returns: VIDEO, from URL, where ACTION is performed at every KEYWORD

import os
import httplib2
import sys

from apiclient.discovery import build_from_document
from apiclient.errors import HttpError
from oauth2client.client import flow_from_clientsecrets
from oauth2client.file import Storage
from oauth2client.tools import argparser, run_flow
from flask import Flask
from flask import request
from flask import jsonify
from flask import render_template
import json
import datetime
import webbrowser

from apiclient.discovery import build_from_document
from apiclient.errors import HttpError
from oauth2client.client import flow_from_clientsecrets
from oauth2client.file import Storage
from oauth2client.tools import argparser, run_flow

CLIENT_SECRETS_FILE = "client_sectres.JSON"
YOUTUBE_READ_WRITE_SSL_SCOPE = "https://www.googleapis.com/auth/youtube.force-ssl"
YOUTUBE_API_SERVICE_NAME = "youtube"
YOUTUBE_API_VERSION = "v3"

MISSING_CLIENT_SECRETS_MESSAGE = "blurp"
 
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
    
# Authorize the request and store authorization credentials.
def get_authenticated_service():
  flow = flow_from_clientsecrets(CLIENT_SECRETS_FILE, scope=YOUTUBE_READ_WRITE_SSL_SCOPE,
    message=MISSING_CLIENT_SECRETS_MESSAGE)

  storage = Storage("teamidk-oauth2.json")
  credentials = storage.get()

  if credentials is None or credentials.invalid:
    credentials = run_flow(flow, storage, args)

  # Trusted testers can download this discovery document from the developers page
  # and it should be in the same directory with the code.
  with open("youtube-v3-api-captions.json", "r") as f:
    doc = f.read()
    return build_from_document(doc, http=credentials.authorize(httplib2.Http()))

# Call the API's captions.download method to download an existing caption track.
def download_caption(youtube, caption_id, tfmt):
                subtitle = youtube.captions().download(
                id=caption_id,
                tfmt=tfmt
                ).execute()
                print("First line of caption track: %s" % (subtitle))
                return "First line of caption track: %s" % (subtitle)
  
def editor(url, key, act):

    website = 'youtube.com'
    if website in url:
        youtube = get_authenticated_service()
        print(youtube)
        return download_caption(youtube,url.split("?",1)[1], "sbv")
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
    
