eix-sync
eselect news read new
emerge --ask --verbose --update --keep-going --backtrack=100 --deep --newuse --with-bdeps=y @world
doas -u $DOAS_USER cp --force --reflink=auto /var/lib/portage/world $GENTOO_CONFIG_DIR/var/lib/portage/world
doas -u $DOAS_USER cargo install-update -a
npm update -g