doas -u $DOAS_USER killall firefox
cp --force --reflink=auto /home/$DOAS_USER/Configuration/policies.json /usr/lib64/firefox/distribution/policies.json
doas -u $DOAS_USER rm --recursive --force /home/$DOAS_USER/.local/share/firefoxpwa/runtime/*
doas -u $DOAS_USER cp --recursive --force --reflink=always /usr/lib64/firefox/* /home/$DOAS_USER/.local/share/firefoxpwa/runtime
doas -u $DOAS_USER /usr/share/system-scripts/update-firefox/update-firefox-profile.sh .mozilla/firefox/tiuh6kpf.default $DOAS_USER