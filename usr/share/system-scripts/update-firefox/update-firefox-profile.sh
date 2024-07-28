#!/bin/bash
FIREFOXPREFSPATH="/home/$2/Configuration/firefox-prefs/"
export FIREFOXPROFILEPATH="/home/$2/$1"
FIREFOXPWASRCPATH="/tmp/firefoxpwa-src/native/userchrome"
shopt -s extglob
rm -r $FIREFOXPROFILEPATH/!(places.sqlite|favicons.sqlite|permissions.sqlite|cookies.sqlite|system-scripts|storage)
shopt -u extglob
if [ -f "$FIREFOXPROFILEPATH/system-scripts/prefs.list" ]; then
	sed "s|.*|$FIREFOXPREFSPATH&|g" $FIREFOXPROFILEPATH/system-scripts/prefs.list | while read -r PREF; do cat $PREF >> "$FIREFOXPROFILEPATH/user.js"; done
fi
mkdir $FIREFOXPROFILEPATH/extensions
cp /usr/lib64/firefox/system-scripts/langpack-fr@firefox.mozilla.org.xpi $FIREFOXPROFILEPATH/extensions/langpack-fr@firefox.mozilla.org.xpi
if [ -f "$FIREFOXPROFILEPATH/system-scripts/ext.list" ]; then
	sed "s|.*|/usr/share/system-scripts/update-firefox/extension/&|g" $FIREFOXPROFILEPATH/system-scripts/ext.list | while read -r EXTENSION; do source $EXTENSION; done
fi
if [ -f "$FIREFOXPROFILEPATH/system-scripts/actions.list" ]; then
	sed "s|.*|/usr/share/system-scripts/update-firefox/actions/&|g" $FIREFOXPROFILEPATH/system-scripts/actions.list | while read -r ACTIONS; do cat $ACTIONS; done | python
fi
if [[ "$1" == *firefoxpwa* ]]; then
	cp -rf "$FIREFOXPWASRCPATH/profile/chrome/." "$FIREFOXPROFILEPATH/chrome"
fi