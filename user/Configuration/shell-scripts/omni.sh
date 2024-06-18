#!/usr/bin/env bash

mkdir /tmp/omni
cd /tmp/omni
unzip -q /usr/lib64/firefox/omni.ja
rm -rf dictionaries
rm -rf hyphenation
rm -rf localization
sed -i '/const SECURITY_STATE_SIGNER = /c\const SECURITY_STATE_SIGNER = "";' modules/psm/RemoteSecuritySettings.sys.mjs
zip -0DXqr omni.ja *
doas cp omni.ja /usr/lib64/firefox/omni.ja