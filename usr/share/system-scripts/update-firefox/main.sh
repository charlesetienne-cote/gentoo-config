doas -u $DOAS_USER killall firefox
cp --force --reflink=auto /home/$DOAS_USER/Configuration/policies.json /usr/lib64/firefox/distribution/policies.json
doas -u $DOAS_USER rm --recursive --force /home/$DOAS_USER/.local/share/firefoxpwa/runtime/*
doas -u $DOAS_USER cp --recursive --force --reflink=always /usr/lib64/firefox/* /home/$DOAS_USER/.local/share/firefoxpwa/runtime
doas -u $DOAS_USER /usr/share/system-scripts/update-firefox/update-firefox-profile.sh .mozilla/firefox/tiuh6kpf.default $DOAS_USER
doas -u $DOAS_USER /usr/share/system-scripts/update-firefox/update-firefox-profile.sh .mozilla/firefox/3v4f2jgx.Vanilla $DOAS_USER
doas -u $DOAS_USER /usr/share/system-scripts/update-firefox/update-firefox-profile.sh .local/share/firefoxpwa/profiles/01HG8VMTPMBMRZQXJKKDEQH6KS $DOAS_USER
doas -u $DOAS_USER /usr/share/system-scripts/update-firefox/update-firefox-profile.sh .local/share/firefoxpwa/profiles/01HG8W8V0HE1T552RSDE6T5S4F $DOAS_USER
doas -u $DOAS_USER /usr/share/system-scripts/update-firefox/update-firefox-profile.sh .local/share/firefoxpwa/profiles/01HJ1KP19PYVD4GAMRV06VD3B4 $DOAS_USER
doas -u $DOAS_USER /usr/share/system-scripts/update-firefox/update-firefox-profile.sh .local/share/firefoxpwa/profiles/01HWRZKY7VECNT8ZQHKJYKESN5 $DOAS_USER