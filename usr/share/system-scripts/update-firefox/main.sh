doas -u $DOAS_USER killall -q firefox
cp --force --reflink=auto /home/$DOAS_USER/Configuration/policies.json /usr/lib64/firefox/distribution/policies.json
doas -u $DOAS_USER rm --recursive --force /home/$DOAS_USER/.local/share/firefoxpwa/runtime/*
doas -u $DOAS_USER cp --recursive --force --reflink=always /usr/lib64/firefox/* /home/$DOAS_USER/.local/share/firefoxpwa/runtime
if [ ! -d /tmp/firefoxpwa-src ]; then
	doas -u $DOAS_USER rm -rf "/tmp/firefoxpwa-src"
	doas -u $DOAS_USER mkdir -p "/tmp/firefoxpwa-src/native/userchrome"
	cd "/tmp/firefoxpwa-src"
	doas -u $DOAS_USER git init
	doas -u $DOAS_USER git remote add origin -f "https://github.com/filips123/PWAsForFirefox.git"
	doas -u $DOAS_USER git sparse-checkout set native/userchrome/
	doas -u $DOAS_USER git pull origin main
fi
cd "/tmp/firefoxpwa-src"
cp -rf "/tmp/firefoxpwa-src/native/userchrome/runtime/." "/usr/lib64/firefox"
doas -u $DOAS_USER /usr/share/system-scripts/update-firefox/update-firefox-profile.sh .mozilla/firefox/tiuh6kpf.default $DOAS_USER
doas -u $DOAS_USER /usr/share/system-scripts/update-firefox/update-firefox-profile.sh .mozilla/firefox/3v4f2jgx.Vanilla $DOAS_USER
doas -u $DOAS_USER /usr/share/system-scripts/update-firefox/update-firefox-profile.sh .local/share/firefoxpwa/profiles/01HG8VMTPMBMRZQXJKKDEQH6KS $DOAS_USER
doas -u $DOAS_USER /usr/share/system-scripts/update-firefox/update-firefox-profile.sh .local/share/firefoxpwa/profiles/01HG8W8V0HE1T552RSDE6T5S4F $DOAS_USER
doas -u $DOAS_USER /usr/share/system-scripts/update-firefox/update-firefox-profile.sh .local/share/firefoxpwa/profiles/01HJ1KP19PYVD4GAMRV06VD3B4 $DOAS_USER
doas -u $DOAS_USER /usr/share/system-scripts/update-firefox/update-firefox-profile.sh .local/share/firefoxpwa/profiles/01HWRZKY7VECNT8ZQHKJYKESN5 $DOAS_USER
doas -u $DOAS_USER /usr/share/system-scripts/update-firefox/update-firefox-profile.sh .local/share/firefoxpwa/profiles/01HY94KARFG0D60D5ZK319VM9D $DOAS_USER