if [ $(whoami) = 'root' ]; then
	echo "You can't do this as root"
else
	exec doas bash "$1"
fi