until emerge --verbose --update --backtrack=100 --deep --newuse --with-bdeps=y --jobs=1 @world
do
	echo "Retrying at `date -Iminutes`"
done