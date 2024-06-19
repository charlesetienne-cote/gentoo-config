cd /home/$WHOAMI/Git/FreeTubeAndroid
yarn --pure-lockfile clean
yarn --pure-lockfile upgrade
yarn --pure-lockfile pack:web