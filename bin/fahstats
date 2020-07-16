#!/usr/bin/env python3

import json
import pprint
import sys
import time

import requests

API = f"https://stats.foldingathome.org/api/donor/"

if bool(len(sys.argv)):
    donor = sys.argv[1]
else:
    exit("need to specify a donor")

while True:
    r = requests.get(f"{API}/{donor}")
    if r.status_code:
        data = json.loads(r.text)
        print(
            f"{donor}: rank {data['rank']} with {data['wus']} WUS and credit {data['credit']}"
        )
    time.sleep(60)
