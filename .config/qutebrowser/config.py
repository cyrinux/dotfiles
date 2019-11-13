# Autogenerated config.py
# Documentation:
#   qute://help/configuring.html
#   qute://help/settings.html

# Uncomment this to still load settings configured via autoconfig.yml
# config.load_autoconfig()

# Automatically start playing `<video>` elements. Note: On Qt < 5.11,
# this option needs a restart and does not support URL patterns.
# Type: Bool
c.content.autoplay = False

# Store cookies. Note this option needs a restart with QtWebEngine on Qt
# < 5.9.
# Type: Bool
c.content.cookies.store = False

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'file://*')

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'chrome://*/*')

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'qute://*/*')

# Editor (and arguments) to use for the `open-editor` command. The
# following placeholders are defined: * `{file}`: Filename of the file
# to be edited. * `{line}`: Line in which the caret is found in the
# text. * `{column}`: Column in which the caret is found in the text. *
# `{line0}`: Same as `{line}`, but starting from index 0. * `{column0}`:
# Same as `{column}`, but starting from index 0.
# Type: ShellCommand
c.editor.command = ['kitty', '--title', 'edit_text', '--class', 'edit_text', 'vim {}']

# Languages to use for spell checking. You can check for available
# languages and install dictionaries using scripts/dictcli.py. Run the
# script with -h/--help for instructions.
# Type: List of String
# Valid values:
#   - af-ZA: Afrikaans (South Africa)
#   - bg-BG: Bulgarian (Bulgaria)
#   - ca-ES: Catalan (Spain)
#   - cs-CZ: Czech (Czech Republic)
#   - da-DK: Danish (Denmark)
#   - de-DE: German (Germany)
#   - el-GR: Greek (Greece)
#   - en-AU: English (Australia)
#   - en-CA: English (Canada)
#   - en-GB: English (United Kingdom)
#   - en-US: English (United States)
#   - es-ES: Spanish (Spain)
#   - et-EE: Estonian (Estonia)
#   - fa-IR: Farsi (Iran)
#   - fo-FO: Faroese (Faroe Islands)
#   - fr-FR: French (France)
#   - he-IL: Hebrew (Israel)
#   - hi-IN: Hindi (India)
#   - hr-HR: Croatian (Croatia)
#   - hu-HU: Hungarian (Hungary)
#   - id-ID: Indonesian (Indonesia)
#   - it-IT: Italian (Italy)
#   - ko: Korean
#   - lt-LT: Lithuanian (Lithuania)
#   - lv-LV: Latvian (Latvia)
#   - nb-NO: Norwegian (Norway)
#   - nl-NL: Dutch (Netherlands)
#   - pl-PL: Polish (Poland)
#   - pt-BR: Portuguese (Brazil)
#   - pt-PT: Portuguese (Portugal)
#   - ro-RO: Romanian (Romania)
#   - ru-RU: Russian (Russia)
#   - sh: Serbo-Croatian
#   - sk-SK: Slovak (Slovakia)
#   - sl-SI: Slovenian (Slovenia)
#   - sq: Albanian
#   - sr: Serbian
#   - sv-SE: Swedish (Sweden)
#   - ta-IN: Tamil (India)
#   - tg-TG: Tajik (Tajikistan)
#   - tr-TR: Turkish (Turkey)
#   - uk-UA: Ukrainian (Ukraine)
#   - vi-VN: Vietnamese (Viet Nam)
c.spellcheck.languages = ['en-US', 'fr-FR']

# Open new tabs (middleclick/ctrl+click) in the background.
# Type: Bool
c.tabs.background = True

# Search engines which can be used via the address bar. Maps a search
# engine name (such as `DEFAULT`, or `ddg`) to a URL with a `{}`
# placeholder. The placeholder will be replaced by the search term, use
# `{{` and `}}` for literal `{`/`}` signs. The search engine named
# `DEFAULT` is used when `url.auto_search` is turned on and something
# else than a URL was entered to be opened. Other search engines can be
# used by prepending the search engine name to the search term, e.g.
# `:open google qutebrowser`.
# Type: Dict
c.url.searchengines = {'DEFAULT': 'https://duckduckgo.com/?kae=d&k1=-1&kk=-1&kak=-1&kax=-1&kaq=-1&kap=-1&kao=-1&kau=-1&kba=-1&q={}', 'ddg': 'https://duckduckgo.com/?kae=d&k1=-1&kk=-1&kak=-1&kax=-1&kaq=-1&kap=-1&kao=-1&kau=-1&kba=-1&q={}'}

# Page(s) to open at the start.
# Type: List of FuzzyUrl, or FuzzyUrl
c.url.start_pages = ['https://duckduckgo.com/?kae=d&k1=-1&kk=-1&kak=-1&kax=-1&kaq=-1&kap=-1&kao=-1&kau=-1&kba=-1']

# Text color of the completion widget. May be a single color to use for
# all columns or a list of three colors, one for each column.
# Type: List of QtColor, or QtColor
c.colors.completion.fg = '#c5c8c6'

# Background color of the completion widget for odd rows.
# Type: QssColor
c.colors.completion.odd.bg = '#969896'

# Background color of the completion widget for even rows.
# Type: QssColor
c.colors.completion.even.bg = '#1d1f21'

# Foreground color of completion widget category headers.
# Type: QtColor
c.colors.completion.category.fg = '#f0c674'

# Background color of the completion widget category headers.
# Type: QssColor
c.colors.completion.category.bg = '#1d1f21'

# Top border color of the completion widget category headers.
# Type: QssColor
c.colors.completion.category.border.top = '#1d1f21'

# Bottom border color of the completion widget category headers.
# Type: QssColor
c.colors.completion.category.border.bottom = '#1d1f21'

# Foreground color of the selected completion item.
# Type: QtColor
c.colors.completion.item.selected.fg = '#282a2e'

# Background color of the selected completion item.
# Type: QssColor
c.colors.completion.item.selected.bg = '#f0c674'

# Top border color of the selected completion item.
# Type: QssColor
c.colors.completion.item.selected.border.top = '#f0c674'

# Bottom border color of the selected completion item.
# Type: QssColor
c.colors.completion.item.selected.border.bottom = '#f0c674'

# Foreground color of the matched text in the completion.
# Type: QtColor
c.colors.completion.match.fg = '#b5bd68'

# Color of the scrollbar handle in the completion view.
# Type: QssColor
c.colors.completion.scrollbar.fg = '#c5c8c6'

# Color of the scrollbar in the completion view.
# Type: QssColor
c.colors.completion.scrollbar.bg = '#1d1f21'

# Background color for the download bar.
# Type: QssColor
c.colors.downloads.bar.bg = '#1d1f21'

# Color gradient start for download text.
# Type: QtColor
c.colors.downloads.start.fg = '#1d1f21'

# Color gradient start for download backgrounds.
# Type: QtColor
c.colors.downloads.start.bg = '#81a2be'

# Color gradient end for download text.
# Type: QtColor
c.colors.downloads.stop.fg = '#1d1f21'

# Color gradient stop for download backgrounds.
# Type: QtColor
c.colors.downloads.stop.bg = '#8abeb7'

# Foreground color for downloads with errors.
# Type: QtColor
c.colors.downloads.error.fg = '#cc6666'

# Font color for hints.
# Type: QssColor
c.colors.hints.fg = '#1d1f21'

# Background color for hints. Note that you can use a `rgba(...)` value
# for transparency.
# Type: QssColor
c.colors.hints.bg = '#f0c674'

# Font color for the matched part of hints.
# Type: QtColor
c.colors.hints.match.fg = '#c5c8c6'

# Text color for the keyhint widget.
# Type: QssColor
c.colors.keyhint.fg = '#c5c8c6'

# Highlight color for keys to complete the current keychain.
# Type: QssColor
c.colors.keyhint.suffix.fg = '#c5c8c6'

# Background color of the keyhint widget.
# Type: QssColor
c.colors.keyhint.bg = '#1d1f21'

# Foreground color of an error message.
# Type: QssColor
c.colors.messages.error.fg = '#1d1f21'

# Background color of an error message.
# Type: QssColor
c.colors.messages.error.bg = '#cc6666'

# Border color of an error message.
# Type: QssColor
c.colors.messages.error.border = '#cc6666'

# Foreground color of a warning message.
# Type: QssColor
c.colors.messages.warning.fg = '#1d1f21'

# Background color of a warning message.
# Type: QssColor
c.colors.messages.warning.bg = '#b294bb'

# Border color of a warning message.
# Type: QssColor
c.colors.messages.warning.border = '#b294bb'

# Foreground color of an info message.
# Type: QssColor
c.colors.messages.info.fg = '#c5c8c6'

# Background color of an info message.
# Type: QssColor
c.colors.messages.info.bg = '#1d1f21'

# Border color of an info message.
# Type: QssColor
c.colors.messages.info.border = '#1d1f21'

# Foreground color for prompts.
# Type: QssColor
c.colors.prompts.fg = '#c5c8c6'

# Border used around UI elements in prompts.
# Type: String
c.colors.prompts.border = '#1d1f21'

# Background color for prompts.
# Type: QssColor
c.colors.prompts.bg = '#1d1f21'

# Background color for the selected item in filename prompts.
# Type: QssColor
c.colors.prompts.selected.bg = '#f0c674'

# Foreground color of the statusbar.
# Type: QssColor
c.colors.statusbar.normal.fg = '#b5bd68'

# Background color of the statusbar.
# Type: QssColor
c.colors.statusbar.normal.bg = '#1d1f21'

# Foreground color of the statusbar in insert mode.
# Type: QssColor
c.colors.statusbar.insert.fg = '#1d1f21'

# Background color of the statusbar in insert mode.
# Type: QssColor
c.colors.statusbar.insert.bg = '#81a2be'

# Foreground color of the statusbar in passthrough mode.
# Type: QssColor
c.colors.statusbar.passthrough.fg = '#1d1f21'

# Background color of the statusbar in passthrough mode.
# Type: QssColor
c.colors.statusbar.passthrough.bg = '#8abeb7'

# Foreground color of the statusbar in private browsing mode.
# Type: QssColor
c.colors.statusbar.private.fg = '#1d1f21'

# Background color of the statusbar in private browsing mode.
# Type: QssColor
c.colors.statusbar.private.bg = '#969896'

# Foreground color of the statusbar in command mode.
# Type: QssColor
c.colors.statusbar.command.fg = '#c5c8c6'

# Background color of the statusbar in command mode.
# Type: QssColor
c.colors.statusbar.command.bg = '#1d1f21'

# Foreground color of the statusbar in private browsing + command mode.
# Type: QssColor
c.colors.statusbar.command.private.fg = '#c5c8c6'

# Background color of the statusbar in private browsing + command mode.
# Type: QssColor
c.colors.statusbar.command.private.bg = '#1d1f21'

# Foreground color of the statusbar in caret mode.
# Type: QssColor
c.colors.statusbar.caret.fg = '#1d1f21'

# Background color of the statusbar in caret mode.
# Type: QssColor
c.colors.statusbar.caret.bg = '#b294bb'

# Foreground color of the statusbar in caret mode with a selection.
# Type: QssColor
c.colors.statusbar.caret.selection.fg = '#1d1f21'

# Background color of the statusbar in caret mode with a selection.
# Type: QssColor
c.colors.statusbar.caret.selection.bg = '#81a2be'

# Background color of the progress bar.
# Type: QssColor
c.colors.statusbar.progress.bg = '#81a2be'

# Default foreground color of the URL in the statusbar.
# Type: QssColor
c.colors.statusbar.url.fg = '#c5c8c6'

# Foreground color of the URL in the statusbar on error.
# Type: QssColor
c.colors.statusbar.url.error.fg = '#cc6666'

# Foreground color of the URL in the statusbar for hovered links.
# Type: QssColor
c.colors.statusbar.url.hover.fg = '#c5c8c6'

# Foreground color of the URL in the statusbar on successful load
# (http).
# Type: QssColor
c.colors.statusbar.url.success.http.fg = '#8abeb7'

# Foreground color of the URL in the statusbar on successful load
# (https).
# Type: QssColor
c.colors.statusbar.url.success.https.fg = '#b5bd68'

# Foreground color of the URL in the statusbar when there's a warning.
# Type: QssColor
c.colors.statusbar.url.warn.fg = '#b294bb'

# Background color of the tab bar.
# Type: QssColor
c.colors.tabs.bar.bg = '#1d1f21'

# Color gradient start for the tab indicator.
# Type: QtColor
c.colors.tabs.indicator.start = '#81a2be'

# Color gradient end for the tab indicator.
# Type: QtColor
c.colors.tabs.indicator.stop = '#8abeb7'

# Color for the tab indicator on errors.
# Type: QtColor
c.colors.tabs.indicator.error = '#cc6666'

# Foreground color of unselected odd tabs.
# Type: QtColor
c.colors.tabs.odd.fg = '#c5c8c6'

# Background color of unselected odd tabs.
# Type: QtColor
c.colors.tabs.odd.bg = '#969896'

# Foreground color of unselected even tabs.
# Type: QtColor
c.colors.tabs.even.fg = '#c5c8c6'

# Background color of unselected even tabs.
# Type: QtColor
c.colors.tabs.even.bg = '#1d1f21'

# Foreground color of selected odd tabs.
# Type: QtColor
c.colors.tabs.selected.odd.fg = '#1d1f21'

# Background color of selected odd tabs.
# Type: QtColor
c.colors.tabs.selected.odd.bg = '#c5c8c6'

# Foreground color of selected even tabs.
# Type: QtColor
c.colors.tabs.selected.even.fg = '#1d1f21'

# Background color of selected even tabs.
# Type: QtColor
c.colors.tabs.selected.even.bg = '#c5c8c6'