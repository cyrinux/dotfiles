import os

import setproctitle

setproctitle.setproctitle("qutebrowser")

config.load_autoconfig(False)

# ui
config.source("/home/cyril/.config/qutebrowser/gruvbox.py")

c.colors.webpage.preferred_color_scheme = "dark"
c.completion.shrink = True
c.completion.use_best_match = True
c.statusbar.widgets = ["progress", "keypress", "url", "history"]
c.scrolling.bar = "always"
c.tabs.position = "left"
c.tabs.title.format = "{index}: {audio}{current_title}"
c.tabs.title.format_pinned = "{index}: {audio}{current_title}"

c.colors.tabs.selected.even.bg = "#504955"
c.colors.tabs.selected.even.fg = "#d79921"

# general
c.auto_save.session = True
c.session.lazy_restore = True
c.content.default_encoding = "utf-8"
c.tabs.show = "multiple"
c.content.javascript.can_access_clipboard = True
c.content.notifications.enabled = True  # notifications aren't supported now anyway
c.editor.command = ["kitty", "kak", "-e", "exec {line}g{column0}l", "{}"]
c.fileselect.handler = "external"
c.fileselect.folder.command = ["kitty", "sh", "-c", "xplr > {}"]
c.fileselect.single_file.command = ["kitty", "sh", "-c", "xplr > {}"]
c.fileselect.multiple_files.command = ["kitty", "sh", "-c", "xplr > {}"]
c.downloads.location.prompt = False
c.downloads.location.directory = "~/Downloads/"
c.downloads.position = "bottom"
c.downloads.remove_finished = 10000
c.input.insert_mode.auto_load = True
c.tabs.last_close = "close"
c.tabs.mousewheel_switching = False
c.spellcheck.languages = ["en-US", "fr-FR"]
c.hints.auto_follow = "full-match"
c.hints.dictionary = "/usr/share/dict/french"
c.hints.mode = "word"

c.content.webrtc_ip_handling_policy = "default-public-interface-only"
c.content.site_specific_quirks.enabled = False
c.content.headers.user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36"

c.content.cookies.accept = "no-3rdparty"
c.content.autoplay = False


c.content.canvas_reading = False
c.content.blocking.enabled = True

with config.pattern("*://*.dm.gg/") as p:
    p.content.autoplay = True
    c.content.canvas_reading = True
    c.content.site_specific_quirks.enabled = (
        True  # Change to True to be able to login to google
    )

c.url.searchengines = {
    "DEFAULT": "https://google.com/search?q={}",
    "?": "https://encrypted.google.com/search?hl=fr&q={}",
    "g": "https://encrypted.google.com/search?hl=fr&q={}",
    "gt": "https://translate.google.com/{}",
    "gm": "https://www.google.com/maps?q={}",
    "dd": "https://duckduckgo.com/?&kn=1&kam=osm&kaj=m&kaq=-1&kao=-1&kau=-1&kp=-2&q={}",
    "e": "https://emojipedia.org/search/?q={}",
    "gh": "https://github.com/search?q={}",
    "y": "https://www.invidio.us/search?q={}",
    "w": "https://fr.wikipedia.org/w/index.php?search={}",
    "http": "https://httpstatuses.com/{}",
    "dict": "https://www.dict.cc/?s={}",
    "s": "https://search.levis.ws/?q={}",
    "c": "https://artifacthub.io/packages/search?ts_query_web={}",
}

c.url.default_page = "chrome://network-error/-106"
c.url.start_pages = ["chrome://network-error/-106"]

c.content.user_stylesheets = ["~/.config/qutebrowser/user.css"]

# keys
bindings = {
    ",b": "config-cycle colors.webpage.bg '#1d2021' 'white'",
    "co": "nop",
    ",C": "spawn cglaunch chromium '{url}'",
    ",c": "spawn --userscript stream",
    "<Ctrl-Shift-D>": "tab-give",
    "<Ctrl-Shift-J>": "tab-move +",
    "<Ctrl-Shift-K>": "tab-move -",
    ",D": "download-open",
    ",g": "spawn --userscript open-portal",
    ";I": "hint images download",
    ",m": "hint links spawn cglaunch mpv --force-window=immediate '{hint-url}'",
    "M": "nop",
    ",M": "spawn cglaunch mpv --force-window=immediate --no-terminal --keep-open=yes --ytdl '{url}'",
    # ",M": "spawn --userscript view_in_mpv '{url}'",
    "o": "set-cmd-text -s :open -s",
    "O": "set-cmd-text -s :open -t -s",
    ",p": "spawn --userscript qute-pass --username-target secret --username-pattern 'user: (.+)' --dmenu-invocation 'dmenu -p credentials'",
    ",P": "spawn --userscript qute-pass --username-target secret --username-pattern 'user: (.+)' --dmenu-invocation 'dmenu -p password' --password-only",
    ",qP": "spawn qbpm launch personal {url}; tab-close",
    ",qW": "spawn qbpm launch work  {url}; tab-close",
    "<Shift-Escape>": "fake-key <Escape>",
    ",s": "open https://rss.levis.name/bookmarklet?uri={url}",
    ",W": "hint links spawn --userscript send_to_wallabag {hint-url}",
    "wo": "set-cmd-text -s :open -w -s",
    ",w": "spawn --userscript send_to_wallabag",
    "xjf": "set content.javascript.enabled false",
    "xjn": "set content.javascript.enabled true",
    "xx": "config-cycle tabs.show always switching",
    "z": "spawn --userscript dmenu_qutebrowser",
}

for key, bind in bindings.items():
    config.bind(key, bind)

# per-domain settings
config.set("content.register_protocol_handler", True, "*://*.levis.name")
config.set("content.cookies.accept", "all", "*://*.dailymotion.com")
config.set("content.cookies.accept", "all", "*://*.dm.gg")
config.set("content.register_protocol_handler", True, "*://calendar.google.com")
config.set("content.register_protocol_handler", True, "*://teams.microsoft.com")
config.set("content.media.audio_video_capture", True, "*://teams.microsoft.com")
config.set("content.media.audio_capture", True, "*://teams.microsoft.com")
config.set("content.media.video_capture", True, "*://teams.microsoft.com")
config.set("content.desktop_capture", True, "*://teams.microsoft.com")
config.set("content.cookies.accept", "all", "*://teams.microsoft.com")
config.set("content.register_protocol_handler", False, "*://outlook.office365.com")
