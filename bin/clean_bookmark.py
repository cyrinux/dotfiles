#!/usr/bin/env python3
# cleanup qutebrowsr bookmarks
import os
import re
import time

import requests

bookmarks = open("urls", "r")
bookmarks_cleaned = open("urls_cleaned", "w")

broken_links = []

for line in bookmarks:
    bookmark = line.strip()
    url = re.match(
        "http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\(\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+",
        bookmark,
    )
    if not url:
        continue
    url = url[0]

    try:
        r = requests.get(url)
        print(f"url: {url} return code {r.status_code}")
        if r.status_code == 404:
            broken_links.append(url)
        else:
            bookmarks_cleaned.write(line)
    except:
        print(f"url: {url} is unreachable")
        broken_links.append(url)

    time.sleep(0.1)


print(broken_links)

bookmarks_cleaned.close()
