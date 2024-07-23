if [ ! -f "$FIREFOXPROFILEPATH/extensions/uBlock0@raymondhill.net.xpi" ]; then
	cd /tmp
	UBLOCK_VERSION=$(curl -v https://github.com/gorhill/uBlock/releases/latest 2> >(sed -n 's/^.*location.*tag\///p') | tr -d '\r')
	if [ ! -d "/tmp/uBlock-$UBLOCK_VERSION" ]; then
		wget --output-document="ublock.tar.gz" "https://github.com/gorhill/uBlock/archive/refs/tags/$UBLOCK_VERSION.tar.gz"
		tar -xzf "ublock.tar.gz"
	fi
	cd "/tmp/uBlock-$UBLOCK_VERSION"
	sed -i 's/window.confirm(msg)/true/g' src/js/settings.js
	sed -i 's/, startImportFilePicker/, handleImportFilePicker/' src/js/settings.js
	make --silent firefox
	cp dist/build/uBlock0.firefox.xpi "$FIREFOXPROFILEPATH/extensions/uBlock0@raymondhill.net.xpi"
fi