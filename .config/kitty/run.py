#!/usr/bin/env python3

import subprocess
from typing import List

from kitty.boss import Boss


def main(args: List[str]) -> str:
    result = subprocess.run(args[1:], stdout=subprocess.PIPE)
    return result.stdout.decode("utf-8")


def handle_result(
    args: List[str], answer: str, target_window_id: int, boss: Boss
) -> None:
    w = boss.window_id_map.get(target_window_id)
    if w is not None:
        w.paste_text(answer)
