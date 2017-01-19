# video-manipulator
"X, but Y, every time Z"
Jan 15, 2017
Michael Benimovich, Gabriel Caniglia, and Akash Borde

Remember the meme "Bee Movie, but every time they say Bee it gets faster?"

This project lets you do that with any video you want!

Our project is awebsite takes in a video link and a keyword and returns a new video, sped up every time the keyword is said in the video.

HOW IT WORKS

> HTML frontend receives youtube link, keyword, and specified action.
> Flask server receives data upon form submission
> Downloads video off youtube, automatically choosing an average stream
> lxml scraper downloads captions off of website www.downsub.com (It's like a real shady site but the data is solid)
> Captions are saved to text file
> Program creates array data structure to organize times
> Data structure is analyzed, and returns a 1D array of times
> Processing analyzes the data, and creates the video modification

TO DO (Ranked by Priority)

> Have the python app call the processing program automatically
> Have the final result downloaded and stored in a folder, deleting intially downloaded video
> Upload new video and display to client
> Find a new scraping target, one that is more reliable
> Debug: Scraper and Processing code
> Better error catching
> Host program on an online server
> Cleaner frontend

Created for Uncommon Hacks 2017 
"Automating memes is perfect for the meme hackathon"