import os
import sys

# ui
config.source(os.environ["HOME"] + "/.config/qutebrowser/gruvbox.py")
c.colors.tabs.selected.odd.bg = c.colors.tabs.selected.even.bg
c.colors.webpage.prefers_color_scheme_dark = True
c.completion.shrink = True
c.completion.use_best_match = True
c.statusbar.widgets = ["progress", "keypress", "url", "history"]
c.scrolling.bar = "always"
c.tabs.position = "left"
c.tabs.width = "15%"
c.tabs.title.format = "{index}: {audio}{current_title}"
c.tabs.title.format_pinned = "{index}: {audio}{current_title}"

# use a different color for work container to give visual distinction
if "QUTE_CONTAINER" not in os.environ or os.environ["QUTE_CONTAINER"] == "facebook":
    c.colors.tabs.selected.even.bg = "#B48EAD"
elif os.environ["QUTE_CONTAINER"] == "personal":
    c.colors.tabs.selected.even.bg = "#504955"
    c.colors.tabs.selected.even.fg = "#d79921"
elif os.environ["QUTE_CONTAINER"] == "work":
    c.colors.tabs.selected.even.bg = "#076678"
    c.colors.tabs.selected.even.fg = "#ebdbb2"
elif os.environ["QUTE_CONTAINER"] == "private":
    c.colors.tabs.selected.even.bg = "#282828"
    c.colors.tabs.selected.even.fg = "#cc241d"

# general
c.auto_save.session = True
c.content.default_encoding = "utf-8"
c.content.javascript.can_access_clipboard = True
c.content.notifications = True  # notifications aren't supported now anyway
c.content.pdfjs = True
c.editor.command = ["kitty", "kak", "-e", "exec {line}g{column0}l", "{file}"]
c.downloads.location.prompt = False
c.downloads.location.directory = "~/Downloads/"
c.input.insert_mode.auto_load = True
c.tabs.background = True
c.tabs.last_close = "close"
c.tabs.mousewheel_switching = False
c.qt.args += [
    "enable-gpu-rasterization",
    "enable-features=WebRTCPipeWireCapturer",
]
c.qt.process_model = "process-per-site-instance"
# c.qt.process_model = "process-per-site"
c.spellcheck.languages = ["en-US", "fr-FR"]
c.hints.chars = "qsdfghjklm"


# per-domain settings
config.set("content.register_protocol_handler", True, "*://*.levis.name")
config.set("content.cookies.accept", "all", "*://*.dailymotion.com")
config.set("content.cookies.accept", "all", "*://*.dm.gg")

config.set("content.register_protocol_handler", True, "*://app.slack.com")
config.set("content.media.audio_capture", True, "*://app.slack.com")
config.set("content.media.video_capture", True, "*://app.slack.com")
config.set("content.desktop_capture", True, "*://app.slack.com")

config.set("content.media.audio_capture", True, "*://app.wire.com")
config.set("content.media.video_capture", True, "*://app.wire.com")
config.set("content.desktop_capture", True, "*://app.wire.com")


# privacy
c.content.cookies.accept = "no-3rdparty"
c.content.autoplay = False

with config.pattern("*://*.levis.name/") as p:
    p.content.autoplay = True

c.content.webrtc_ip_handling_policy = "default-public-interface-only"
c.content.site_specific_quirks = False  # Change to True to be able to login to google
c.content.headers.user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.75 Safari/537.36"
c.content.canvas_reading = False
c.content.host_blocking.enabled = True

with config.pattern("*://*.dm.gg/") as p:
    p.content.autoplay = True
    c.content.canvas_reading = True
    c.content.site_specific_quirks = (
        True  # Change to True to be able to login to google
    )

# urls
c.url.searchengines = {
    "DEFAULT": "https://duckduckgo.com/?&kn=1&kam=osm&kaj=m&kaq=-1&kao=-1&kau=-1&kp=-2&q={}",
    "dd": "https://duckduckgo.com/?&kn=1&kam=osm&kaj=m&kaq=-1&kao=-1&kau=-1&kp=-2&q={}",
    "e": "https://emojipedia.org/search/?q={}",
    "g": "https://google.com/search?q={}",
    "gh": "https://github.com/search?q={}",
    "y": "https://www.invidio.us/search?q={}",
    "w": "https://fr.wikipedia.org/w/index.php?search={}",
    "http": "https://httpstatuses.com/{}",
    "dict": "https://www.dict.cc/?s={}",
    "s": "https://search.levis.ws/?q={}",
}

c.url.default_page = "~/.config/qutebrowser/blank.html"
c.url.start_pages = ["~/.config/qutebrowser/blank.html"]


# keys
bindings = {
    "<Ctrl-Shift-J>": "tab-move +",
    "<Ctrl-Shift-K>": "tab-move -",
    ",m": "spawn --userscript view_in_mpv",
    ",M": "hint links spawn mpv {hint-url}",
    ",a": "spawn --userscript youtube-dl-mp3",
    ",A": "hint links userscript youtube-dl-mp3",
    ",d": "spawn --userscript youtube-dl",
    ",D": "hint links userscript youtube-dl",
    ",k": "jseval javascript:(function(){ document.querySelector('html').style.filter = 'invert(1)';})(); })",
    ",p": "spawn --userscript qute-pass --username-target secret --username-pattern 'user: (.+)' --dmenu-invocation 'dmenu -p credentials'",
    ",P": "spawn --userscript qute-pass --username-target secret --username-pattern 'user: (.+)' --dmenu-invocation 'dmenu -p password' --password-only",
    ",w": "spawn --userscript send_to_wallabag",
    ",W": "hint links spawn --userscript send_to_wallabag {hint-url}",
    ",r": "spawn --userscript readability",
    ",c": "spawn --userscript cast",
    ",C": "spawn chromium {url}",
    "xx": "config-cycle tabs.show always switching",
    ",b": "config-cycle colors.webpage.bg '#32302f' 'white'",
    "xjn": "set content.javascript.enabled true",
    "xjf": "set content.javascript.enabled false",
    "M": "nop",
    "co": "nop",
    "<Shift-Escape>": "fake-key <Escape>",
    "o": "set-cmd-text -s :open -s",
    "O": "set-cmd-text -s :open -t -s",
}


for key, bind in bindings.items():
    config.bind(key, bind)
