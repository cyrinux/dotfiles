import os

config.load_autoconfig(False)

# ui
config.source("gruvbox.py")

c.colors.webpage.preferred_color_scheme = "dark"
c.completion.shrink = True
c.completion.use_best_match = True
c.statusbar.widgets = ["progress", "keypress", "url", "history"]
c.scrolling.bar = "always"
c.tabs.position = "left"
c.tabs.title.format = "{index}: {audio}{current_title}"
c.tabs.title.format_pinned = "{index}: {audio}{current_title}"

# use a different color for work container to give visual distinction
if "QUTE_CONTAINER" not in os.environ:
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
c.session.lazy_restore = True
c.content.default_encoding = "utf-8"
c.tabs.show = "multiple"
c.content.javascript.can_access_clipboard = True
c.content.notifications.enabled = True  # notifications aren't supported now anyway
c.content.pdfjs = True
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
c.qt.force_software_rendering = "qt-quick"
c.qt.args += [
    "enable-gpu-rasterization",
    "blink-settings=preferredColorScheme=1",
]
c.spellcheck.languages = ["en-US", "fr-FR"]
c.hints.auto_follow = "full-match"
c.hints.dictionary = "/usr/share/dict/mnemonic"
c.hints.mode = "word"

c.content.webrtc_ip_handling_policy = "default-public-interface-only"
c.content.site_specific_quirks.enabled = False
c.content.headers.user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36"

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
}

c.url.default_page = "~/.config/qutebrowser/blank.html"
c.url.start_pages = ["~/.config/qutebrowser/blank.html"]


# keys
bindings = {
    "<Ctrl-Shift-J>": "tab-move +",
    "<Ctrl-Shift-K>": "tab-move -",
    ",M": "spawn streamlink {url} best --twitch-low-latency --player mpv",
    ",m": "hint links spawn qutebrowser-play '{hint-url}'",
    ",a": "spawn --userscript youtube-dl-mp3",
    ",A": "hint links userscript youtube-dl-mp3",
    ",d": "spawn --userscript youtube-dl",
    ",D": "hint links userscript youtube-dl",
    ",k": "jseval javascript:(function(){ document.querySelector('html').style.filter = 'invert(1)';})(); })",
    ",p": "spawn --userscript qute-pass --username-target secret --username-pattern 'user: (.+)' --dmenu-invocation 'dmenu -p credentials'",
    ",P": "spawn --userscript qute-pass --username-target secret --username-pattern 'user: (.+)' --dmenu-invocation 'dmenu -p password' --password-only",
    ",w": "spawn --userscript send_to_wallabag",
    ",W": "spawn qutebrowser-work {url}",
    ",P": "spawn qutebrowser-personal {url}",
    ",W": "hint links spawn --userscript send_to_wallabag {hint-url}",
    ",r": "spawn --userscript readability",
    ",C": "spawn chromium {url}",
    "xx": "config-cycle tabs.show always switching",
    ",b": "config-cycle colors.webpage.bg '#32302f' 'white'",
    "xjn": "set content.javascript.enabled true",
    "xjf": "set content.javascript.enabled false",
    "M": "nop",
    "co": "nop",
    "<Shift-Escape>": "fake-key <Escape>",
    "wo": "set-cmd-text -s :open -w -s",
    "o": "set-cmd-text -s :open -s",
    "O": "set-cmd-text -s :open -t -s",
    "z": "spawn --userscript dmenu_qutebrowser",
    ",s": "open https://rss.levis.name/bookmarklet?uri={url}",
    ",c": "spawn --userscript stream",
    ",g": "spawn --userscript open-portal",
    ";I": "hint images download",
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
