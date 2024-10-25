cd /home/$DOAS_USER/Git/FreeTubeAndroid
yarn --pure-lockfile clean
yarn --pure-lockfile upgrade
yarn --pure-lockfile pack:web