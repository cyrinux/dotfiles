#!/usr/bin/env python

from subprocess import Popen, PIPE


def main(args):
    p1 = Popen(["pass", "show", "work/ldap"], stdout=PIPE)
    password, _ = p1.communicate()
    return password.decode("utf-8").strip()


def handle_result(args, password, target_window_id, boss):
    window = boss.window_id_map.get(target_window_id)
    if window is not None:
        window.paste(password)


if __name__ == "__main__":
    import sys

    print(main(sys.argv))
