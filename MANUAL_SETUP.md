# Urlwatch

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

# PIA login

```
piactl login <(pass personal/http/privateinternetaccess.com-pactl-login)
```

# Auth by certificat

```
pk12util -d "sql:${HOME}/.pki/nssdb" -i user.p12 -n "My User Certificat"
```

# Import user certificat p12 on a Yubikey (using PIV)

```
$ yubico-piv-tool -s 9a -i thecertificate.p12 -K PKCS12 -a import-key -a import-certificate --touch-policy=always
$ yubico-piv-tool -s 9a -a change-pin (default pin: 123456)
```

# Steam / CyberPunk 2077

## Requirements (on Radeon RX850)

- mesa-git
- steam beta enable
- proton experimental
- launcher command set to `gamemoderun idle-inhibitor %command% --launcher-skip`

# Thunderbolt

```
$ boltctl list
$ boltctl authorize zdazdaz-aaa-xxx-ffff-ffffffffffff
```

# Podman

```
podman login docker.io
podman login quay.io
```

# Thermal management

```
sudo smbios-thermal-ctl --set-thermal-mode=Quiet
```

# Yubikey GPG management from recovery

https://github.com/drduh/YubiKey-Guide

```
sudo pacman -S ccid pcsclite
```
