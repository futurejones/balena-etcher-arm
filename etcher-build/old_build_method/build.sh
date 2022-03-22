#!/bin/bash
echo
echo "✅  Cloning Etcher"
echo
declare version=$1

rm -rf etcher
git clone --recursive https://github.com/balena-io/etcher

if [ $# -eq 0 ]
then
echo
echo "✅  building master"
echo
else
echo
echo "✅  building version $version"
echo
pushd etcher
git checkout $version

if [ $? -eq 0 ]
then
    echo "Checked out version $version"
else
    echo "⚠️   ERROR: '$version' unknown version"
    exit 1
fi
popd
echo "................................................"
fi
echo
echo "✅  Building Etcher"
echo
cp dissable-tiffutil.patch etcher/patches/
pushd etcher
make electron-develop
make electron-build
echo "✅  Finished"
echo
