# Thunderbird

## Preferences

### General:

- Thunderbird Start Page - FALSE

### Privacy:

- Allow remote content - FALSE
- Accept third-party cookies - Never
- Tell sites that I do not want to be tracked - TRUE

### Advanced:

- Enable Global Search and Indexer - TRUE
- Use hardware acceleration - TRUE
- Config editor:
  - `mail.wrap_long_lines` - FALSE
  - `mailnews.wraplength`- 0

## Account settings:

- Junk Settings
  - Adaptive junk - FALSE
  - Trust junk mail headers set by SpamAssassin

## Account settings AND for every identity:

- Composition & Addressing
  - Compose messages in HTML format - FALSE
- OpenPGP Security
  - Enable - TRUE
  - Specific key ID
  - Advanced - Send key ID and URL

## Extensions:

- Enigmail
- Expression Search / Google Mail UI
- GNotifier

# urlwatch

- Configure `mailgun` section in: `$ urlwatch --edit-config`
- Configure `pushover` section in: `$ urlwatch --edit-config`

# Chromium

Search engines:

- Google: `https://google.com/search?q=%s&pws=0&gl=us&gws_rd=cr`
- Google (fr): `https://google.fr/search?q=%s`

# reverse-ssh

- Add `GatewayPorts yes` to `/etc/ssh/sshd_config`

# USBGuard

- Generate and review the policy, potentially removing the `via-port` parameter:

  ```
  # usbguard generate-policy > /etc/usbguard/rules.conf
  ```

# nmtrust

- Set trusted network in /etc/nmtrust/trusted_networks

# firejail

```
# firecfg
```

# Spotify

- start oomox, select Arc-gruvbox-dark theme, then apply spotify theme.

# PIA login

```
piactl login <(pass personal/http/privateinternetaccess.com-pactl-login)
```

# Auth by certificat

```
pk12util -d "sql:${HOME}/.pki/nssdb" -i user.p12 -n "My User Certificat"
```
