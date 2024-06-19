FFVERSION=$(eix --exact www-client/firefox --xml | sed -n 's/^[[:blank:]]*<version id="//p' | sed 's/".*$//g' | tail --lines=1)
if [ ! -d /tmp/firefox-$FFVERSION ]; then
	doas -u $DOAS_USER mkdir /tmp/firefox-$FFVERSION
	doas -u $DOAS_USER tar -xf /var/cache/distfiles/firefox-$FFVERSION.source.tar.xz -C /tmp
	cd /tmp/firefox-$FFVERSION
	doas -u $DOAS_USER git init
	doas -u $DOAS_USER git add .
	doas -u $DOAS_USER git commit -m "$FFVERSION"
	doas -u $DOAS_USER git apply /etc/portage/patches/www-client/firefox/firefox.patch
fi
cd /tmp/firefox-$FFVERSION
doas -u $DOAS_USER bash -c "wget https://codeberg.org/librewolf/settings/raw/branch/master/librewolf.cfg -O - | sed 's/lockPref/pref/g' | sed 's/defaultPref/pref/g' > librewolf.js"
doas -u $DOAS_USER git add .
doas -u $DOAS_USER git diff --staged > $GENTOO_CONFIG_DIR/etc/portage/patches/www-client/firefox/firefox.patch