#!/usr/bin/env python3
from __future__ import print_function
import os
import sys
import time
from collections import OrderedDict

time_mags = OrderedDict(
    [("y", 31557600), ("w", 604800), ("d", 86400), ("h", 3600), ("m", 60), ("s", 1)]
)

def human_seconds(num, max_sf=2):
    notation = ""
    sf = 0
    for suf, size in time_mags.items():
        count = int(num // size)
        num %= size  # remainder
        if count:
            notation += str(count) + suf
            sf += 1
        if sf >= max_sf:
            break

    return notation


def main():
    if len(sys.argv) != 2:
        print("Get the time elapsed since a unix timestamp in an abbreviated format")
        print("Usage: {} <timestamp>".format(sys.argv[0]))
        sys.exit(0)

    start = float(sys.argv[1])
    duration = time.time() - start

    print(human_seconds(duration))


if __name__ == "__main__":
    main()
