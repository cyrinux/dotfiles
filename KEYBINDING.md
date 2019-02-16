# Keyboard shortcuts

## i3 window manager

- <kbd>Shift</kbd>+<kbd>F1</kbd> - sync mail, calendars, contacts
- <kbd>Shift</kbd>+<kbd>F2</kbd> - prompt mount Vault
- <kbd>Mod</kbd>+<kbd>F1</kbd> - restart gpg, fix yubikey issue
- <kbd>Mod</kbd>+<kbd>F2</kbd> - start personal chromium
- <kbd>Mod</kbd>+<kbd>F2</kbd> - open nautilus
- <kbd>Mod</kbd>+<kbd>number</kbd> - switch to workspace
- <kbd>Mod</kbd>+<kbd>Shift</kbd>+<kbd>number</kbd> - send application to workspace
- <kbd>Mod</kbd>+<kbd>n</kbd> - rofi NetworkManager
- <kbd>Mod</kbd>+<kbd>d</kbd> - rofi application launcher
- <kbd>Mod</kbd>+<kbd>=</kbd> - rofi calculator
- <kbd>Alt</kbd>+<kbd>Tab</kbd> - rofi window, application launcher
- <kbd>Mod</kbd>+<kbd>p</kbd> - rofi pass password manager
- <kbd>Mod</kbd>+<kbd>Control</kbd>+<kbd>p</kbd> - rofi keepassx password manager
- <kbd>Mod</kbd>+<kbd>Shift</kbd>+<kbd>p</kbd> - audio menu: pavucontrol, pulseeffects, bluetooth
- <kbd>Mod</kbd>+<kbd>w</kbd> - rofi web search / browser launcher
- <kbd>Mod</kbd>+<kbd>t</kbd> - i3 tabbed view
- <kbd>Mod</kbd>+<kbd>s</kbd> - i3 stacked view
- <kbd>Mod</kbd>+<kbd>e</kbd> - i3 tiled view
- <kbd>Mod</kbd>+<kbd>PrintScr</kbd> - flameshot gui screenshot
- <kbd>PrintScr</kbd> - flameshot full screenshot
- <kbd>Mod</kbd>+<kbd>Shift</kbd>+<kbd>m</kbd> - hide menu bar
- <kbd>Mod</kbd>+<kbd>Shift</kbd>+<kbd>q</kbd> - quit application
- <kbd>Mod</kbd>+<kbd>Escape</kbd> - exit menu: lock, suspend, shutdown, xkill...
- <kbd>Mod</kbd>+<kbd>²</kbd> - show scratchpad
- <kbd>Mod</kbd>+<kbd>Shift</kbd>+<kbd>c</kbd> - reload i3 config
- <kbd>Mod</kbd>+<kbd>Shift</kbd>+<kbd>r</kbd> - restart i3
- <kbd>Mod</kbd> - tape and release mod key alone send <kbd>Esc</kbd>
- <kbd>Mod</kbd>+<kbd>f</kbd> - fullscreen
- <kbd>Mod</kbd>+<kbd>l</kbd> - lock scren
- <kbd>Mod</kbd>+<kbd>b</kbd> - rofi pinboard bookmark
- All medias keys are working, controlling sounds and D-BUS medias app

## Neovim

## Neomutt

- <kbd>o</kbd> - sync mail, calendars, contacts
- <kbd>m</kbd> - write mail, then _p_ to privacy
- <kbd>y</kbd> - add, remove tags to mail
- <kbd>gi</kbd> - go to inbox
- <kbd>gs</kbd> - go to sents
- <kbd>gd</kbd> - go to drafts
- <kbd>gj</kbd> - go to junk
- <kbd>h</kbd> - mark as ham
- <kbd>j</kbd> - mark as junk
- <kbd>v</kbd> - open attachments list
- <kbd>\\</kbd> - search, query by notmuch
- <kbd>Control</kbd>+<kbd>j</kbd> - go down in the sidebar
- <kbd>Control</kbd>+<kbd>k</kbd> - go up in the sidebar
- <kbd>Control</kbd>+<kbd>o</kbd> - open the selected folder in the sidebar
- <kbd>a</kbd> - mark as archive a message
- <kbd>A</kbd> - mark as archive a thread
- <kbd>P</kbd> - archive messages/threads
- <kbd>p</kbd> - print message
- <kbd>X</kbd> - open virtual folder (then <kbd>?</kbd>)

# Misc

## Pass and rofi-pass

- Add a password:

```
addpass --name "My new Site" +user "zeltak" +branch "branch" +custom "foobar" +autotype "branch :tab user :tab pass"
```

- Edit or generate new password from rofi-pass

  Select a password from the list then hit <kbd>Alt</kbd>+<kbd>a</kbd> and select the action.

## rofi application launcher

- <kbd>Control</kbd>+<kbd>Tab</kbd> - switch between rofi modules

  available modules are drun,run,window,dict,ssh,calc,hex
