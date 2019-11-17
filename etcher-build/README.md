# Build Instructions for Raspberry Pi 4 - Raspbian Buster
### clone repo
```
git clone https://github.com/futurejones/balena-etcher-arm.git
cd balena-etcher-arm/etcher-build/
```
### Install dependencies
```
./install_dependencies.sh
```

### Build etcher
Add version number for build or none to build the master
```
# to build master
./build.sh

# to build version v1.5.36
./build.sh v1.5.36
```
NOTE: The build will fail with this error `make: *** [Makefile:112: electron-build] Error 1`.  
This is because the inbuilt electron package system is for x86 machines and is not compatible with the arm cpu on the Raspberry Pi. We will use `dpkg-deb` to package etcher in the next step.
### Package etcher
```
./package_etcher.sh
```
You should now have `balena-etcher-electron_1.5.63+a1558116_raspbian_buster_armhf.deb` in the `etcher-build` directory.
