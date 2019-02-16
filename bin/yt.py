#!/usr/bin/env python2
#install https://developers.google.com/api-client-library/python/ , youtube-dl and mplayer
from apiclient.discovery import build
from apiclient.errors import HttpError
from oauth2client.tools import argparser
import os
# Set DEVELOPER_KEY to the API key value from the APIs & auth > Registered apps
# tab of
#   https://cloud.google.com/console
# Please ensure that you have enabled the YouTube Data API for your project.
DEVELOPER_KEY = "AIzaSyCHHjWwzinp04nYS5Jo27qUawBcSrw4e08"
YOUTUBE_API_SERVICE_NAME = "youtube"
YOUTUBE_API_VERSION = "v3"


def youtube_search(options):
    youtube = build(
        YOUTUBE_API_SERVICE_NAME,
        YOUTUBE_API_VERSION,
        developerKey=DEVELOPER_KEY)
    # Call the search.list method to retrieve results matching the specified
    # query term.
    search_response = youtube.search().list(
        q=options.q,
        type="video",
        safeSearch="none",
        #location=options.location,
        #locationRadius=options.location_radius,
        part="id,snippet",
        maxResults=options.max_results).execute()
    urls = []
    for search_result in search_response.get("items", []):
        urls.append("https://youtube.com/v/" + search_result["id"]["videoId"])
    os.system("youtube-dl -q -o- %s | mpv --profile=big-cache  - &" %
              (urls[0]))


if __name__ == "__main__":
    argparser.add_argument("--q", help="Search term", default="Google")
    #argparser.add_argument("--location", help="Location", default="37.42307,-122.08427")
    #argparser.add_argument("--location-radius", help="Location radius", default="5km")
    argparser.add_argument("--max-results", help="Max results", default=25)
    args = argparser.parse_args()
    try:
        youtube_search(args)
    except HttpError, e:
        print "An HTTP error %d occurred:\n%s" % (e.resp.status, e.content)
