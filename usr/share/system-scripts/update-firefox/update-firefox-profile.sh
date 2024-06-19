#!/bin/bash
FIREFOXPREFSPATH="/home/$2/Configuration/firefox-prefs/"
FIREFOXPROFILEPATH="/home/$2/$1"
rm "$FIREFOXPROFILEPATH/prefs.js"
rm "$FIREFOXPROFILEPATH/user.js"
sed "s|.*|$FIREFOXPREFSPATH&|g" $FIREFOXPROFILEPATH/prefs.list | while read -r PREF; do cat $PREF >> "$FIREFOXPROFILEPATH/user.js"; done