#!/bin/bash
FIREFOXPREFSPATH="/home/$2/Configuration/firefox-prefs/"
FIREFOXPROFILEPATH="/home/$2/$1"
FIREFOXPWASRCPATH="/tmp/firefoxpwa-src/native/userchrome"
rm "$FIREFOXPROFILEPATH/prefs.js"
rm "$FIREFOXPROFILEPATH/user.js"
if [[ ""$1"" == *firefoxpwa* ]]; then
	rm -rf "$FIREFOXPROFILEPATH/chrome/*"
	cp -rf "$FIREFOXPWASRCPATH/profile/chrome/." "$FIREFOXPROFILEPATH/chrome"
fi
sed "s|.*|$FIREFOXPREFSPATH&|g" $FIREFOXPROFILEPATH/prefs.list | while read -r PREF; do cat $PREF >> "$FIREFOXPROFILEPATH/user.js"; done