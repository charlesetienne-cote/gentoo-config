cd /tmp
UBLOCK_VERSION=$(curl -v https://github.com/gorhill/uBlock/releases/latest 2> >(sed -n 's/^.*location.*tag\///p') | tr -d '\r')
wget "https://github.com/gorhill/uBlock/archive/refs/tags/$UBLOCK_VERSION.tar.gz"
tar -xvzf "$UBLOCK_VERSION.tar.gz"
cd "/tmp/uBlock-$UBLOCK_VERSION"
make firefox
cp dist/build/uBlock0.firefox.xpi "$FIREFOXPROFILEPATH/extensions/uBlock0@raymondhill.net.xpi"