# Video Manipulation Program
# Takes in Inputs: URL, KEYWORD, ACTION
# Returns: VIDEO, from URL, where ACTION is performed at every KEYWORD

import os
from glob import glob
from flask import Flask
from flask import request
from flask import jsonify
from flask import render_template
from lxml import html
import urllib
import urllib2
import requests
import pafy
import json
import datetime
import webbrowser

#Path parameter
path = "C:\\Users\\mikeb\\Documents\\Github\\video-manipulator"

#Start server
app = Flask(__name__) 

error = 'none'
@app.route('/', methods=['GET', 'POST'])
def index():
        render_template('index.html')
        
        #If request is posted
	if request.method == 'POST':
	        
	        #Take in the three inputs
		url = request.form['link']
		key = request.form['keyword']
	        act = request.form['action']
	        return collect (url, key, act)
	
	#Render template while waiting for response         
	return render_template('index.html')	
  
def collect(url, key, act):
    
    #Check to see if link is a youtube link
    website = 'youtube.com'
    if website in url:
        
        #Get Video Captions
        captions = getCaptions(url)
        
        #If Captions Do Not Exist
        if captions == "NULL":
            error = "Video does not have captions"
            
            #Return to start
            return render_template('index.html', error = error)
        
        #video_path = getVideo(url) 
        return captions
    
    #If not a youtube link
    else:
        error = "youtube link not provided"
        #Return to Start
        return render_template('index.html', error = error)
        
def getCaptions(url):
    
    #Create the path URL
    code = url.index("=")
    code = code + 1
    webpath = 'https://downsub.com/?url=https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3D' + url[code:];
    
    #Get the text of webpage
    page = requests.get(webpath)
    tree = html.fromstring(page.content)
    dwntext = tree.xpath('//*[@id="show"]/text()[1]')
    
    #If not captions, return NULL
    miss = "Sorry, there are no subtitle available for this video."
    if miss in dwntext[0]:
        return "NULL"
    
    #create the download url    
    dwnlink = tree.xpath('//*[@id="show"]/b/a/@href')
    dwnlink = dwnlink[0]
    dwnlink = 'https://downsub.com' + dwnlink[1:]
    
    #Access File
    req = urllib2.Request(dwnlink, headers={'User-Agent' : 'Mozilla/5.0'})
    response = urllib2.urlopen(req)  
    captionsfile = response.read();
    data = list(captionsfile)
    
    #Get local captions file 
    local = open(path + "\\temp_caption\\captions.txt", 'w')
    
    #write data to txt file
    for element in data:
        local.write(element)
    
    #close files
    local.close()
    response.close()
    
    #return success/fail
    return str(captionsfile)
 
def getVideo(url):
    
    #Get Video Object
    video = pafy.new(url)
    
    #Get List of Stream Quality
    streams = video.streams
    
    #Choose a medium stream
    s_num = len(streams)
    s_choice = s_num//2
    
    #Download video to temp folder
    video_path = streams[s_choice].download(filepath = path + "\\temp_video")
    return video_path    
    
#Run App
if __name__ == '__main__':
        app.debug = True
        port = int(os.environ.get('PORT',5000))
        app.run(host='0.0.0.0', port=port)
	#app.run(debug=True)   