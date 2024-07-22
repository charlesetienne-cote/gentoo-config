#!/bin/bash
FIREFOXPREFSPATH="/home/$2/Configuration/firefox-prefs/"
export FIREFOXPROFILEPATH="/home/$2/$1"
FIREFOXPWASRCPATH="/tmp/firefoxpwa-src/native/userchrome"
rm -f "$FIREFOXPROFILEPATH/prefs.js"
rm -f "$FIREFOXPROFILEPATH/user.js"
rm -rf "$FIREFOXPROFILEPATH/extensions"
rm -f "$FIREFOXPROFILEPATH/extensions.json"
rm -f "$FIREFOXPROFILEPATH/extension-settings.json"
rm -f "$FIREFOXPROFILEPATH/extension-preferences.json"
if [[ ""$1"" == *firefoxpwa* ]]; then
	rm -rf "$FIREFOXPROFILEPATH/chrome/*"
	cp -rf "$FIREFOXPWASRCPATH/profile/chrome/." "$FIREFOXPROFILEPATH/chrome"
fi
sed "s|.*|$FIREFOXPREFSPATH&|g" $FIREFOXPROFILEPATH/prefs.list | while read -r PREF; do cat $PREF >> "$FIREFOXPROFILEPATH/user.js"; done

mkdir $FIREFOXPROFILEPATH/extensions
if [ -f "$FIREFOXPROFILEPATH/ext.list" ]; then
	sed "s|.*|/usr/share/system-scripts/update-firefox/extension/&|g" $FIREFOXPROFILEPATH/ext.list | while read -r EXTENSION; do source $EXTENSION; done
fi