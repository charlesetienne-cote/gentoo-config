if [ ! -f "$FIREFOXPROFILEPATH/extensions/leechblockng@proginosko.com.xpi" ]; then
	cd /tmp
	JQUERY_VERSION=$(curl -v https://github.com/jquery/jquery-ui/releases/latest 2> >(sed -n 's/^.*location.*tag\///p') | tr -d '\r')
	if [ ! -d "/tmp/jquery-ui-$JQUERY_VERSION" ]; then
		wget --output-document="jquery-ui.zip" "https://jqueryui.com/resources/download/jquery-ui-$JQUERY_VERSION.zip"
		unzip -q "jquery-ui.zip"
	fi
	LEECHBLOCK_VERSION=$(curl -v https://github.com/proginosko/LeechBlockNG/releases/latest 2> >(sed -n 's/^.*location.*tag\///p') | tr -d '\r')
	if [ ! -d "/tmp/LeechBlockNG-$(echo $LEECHBLOCK_VERSION | tr -d 'v')" ]; then
		wget --output-document="leechblock.tar.gz" "https://github.com/proginosko/LeechBlockNG/archive/refs/tags/$LEECHBLOCK_VERSION.tar.gz"
		tar -xzf "leechblock.tar.gz"
	fi
	cd "/tmp/LeechBlockNG-$(echo $LEECHBLOCK_VERSION | tr -d 'v')"
	if [ ! -d "/tmp/LeechBlockNG-$(echo $LEECHBLOCK_VERSION | tr -d 'v')/jquery-ui" ]; then
		cp -rf "/tmp/jquery-ui-$JQUERY_VERSION" jquery-ui
	fi
	zip -q -r "$FIREFOXPROFILEPATH/extensions/leechblockng@proginosko.com.xpi" *
fi