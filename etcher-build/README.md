## For armv7 / arm64 / aarch64 - Ubuntu / Debian
*updated 2022/03/21*

After trying many different build combinations, including writing my own packaging script, I have found the following to be the most reliable and consistent method of building Etcher. This method has been tested on a fresh install of Raspberry OS Bullseye on a Raspberry Pi 4.
Also tested on arm64 / aarch64 Ubuntu 20.04 and Debian 11/bullseye

**Build Instructions**
1. Install build dependencies.  
```
sudo apt-get install -y git curl python gcc g++ make libx11-dev libxkbfile-dev fakeroot rpm libsecret-1-dev jq python2.7-dev python3-pip python-setuptools libudev-dev
sudo apt-get install ruby-dev
sudo gem install fpm --no-document #tested with version 1.14.1
#install NodeJS
curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs
```

2. Clone Repo and Checkout Release . 
```
git clone --recursive https://github.com/balena-io/etcher
cd etcher
git checkout v1.7.8 #latest version available 2022/03/21
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
# restrict output to .deb package only to save build time
sed -i 's/TARGETS="deb rpm appimage"/TARGETS="deb"/g' scripts/resin/electron/build.sh
```

6. Build and Package  

```
# Note: run `make electron-develop` before running build.
# use USE_SYSTEM_FPM="true" to force the use of the installed FPM version
USE_SYSTEM_FPM="true" make electron-build 
```

7. Install Package 
```
#  *.deb package will be in /etcher/dist/*
# filename will depend on which release version was checked out
sudo apt-get install ./dist/balena-etcher-electron_<version>-<arch>.deb 
```
Note: You can ignore the `chmod: cannot access '/opt/balenaEtcher/chrome-sandbox': No such file or directory` warning. It is caused by the `postinst` file and is only relevant for electron versions 5+.
