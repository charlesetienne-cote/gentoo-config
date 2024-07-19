cd /tmp
wget https://codeload.github.com/spenibus/cors-everywhere-firefox-addon/zip/refs/heads/master
unzip master
cd cors-everywhere-firefox-addon-master
rm -rf _test
zip "$FIREFOXPROFILEPATH/extensions/cors-everywhere@spenibus.xpi" * media/*