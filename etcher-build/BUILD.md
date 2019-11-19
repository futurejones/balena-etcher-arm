After trying many different build combinations, including writing my own packaging script, I have found the following to be the most reliable and contestant method of building Etcher. This method has been tested on a fresh install of Raspbian Buster on a Raspberry Pi 4.

**Build Instructions**
1. Install build dependencies.  
```
sudo apt-get install -y git python gcc g++ make libx11-dev libxkbfile-dev fakeroot rpm libsecret-1-dev jq python2.7-dev python-pip python-setuptools libudev-dev
sudo apt-get install ruby-dev
sudo gem install fpm -v 1.10.2 #note: must be v1.10.2 NOT v1.11.0
#install NodeJS
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs
```

2. Clone Repo and Checkout Release . 
```
git clone --recursive https://github.com/balena-io/etcher
cd etcher
git checkout v1.5.63
```

3. Install Requirements  
```
pip install -r requirements.txt
```

4. Setup and Install NPM Modules . 
```
make electron-develop
``` 
At this point you should be able to run a test of Etcher with -
```
npm start
```

5. Patch Build Files 
```
# disable tiffutil in the Makefile as this is a Mac only app and will cause the build to fail
sed -i 's/tiffutil/#tiffutil/g' Makefile 
# restrict output to .deb package only to save build time
sed -i 's/TARGETS="deb rpm appimage"/TARGETS="deb"/g' scripts/resin/electron/build.sh
```

6. Build and Package 
```
# use USE_SYSTEM_FPM="true" to force the use of the installed FPM version
USE_SYSTEM_FPM="true" make electron-build 
```

7. Install Package 
```
#  *.deb package will be in /etcher/dist/*
# filename will depend on which release version was checked out
sudo apt-get install ./dist/balena-etcher-electron_1.5.63+a1558116_armv7l.deb 
```
Note: You can ignore the `chmod: cannot access '/opt/balenaEtcher/chrome-sandbox': No such file or directory` warning. It is caused by the `postinst` file and is only relevant for electron versions 5+.
