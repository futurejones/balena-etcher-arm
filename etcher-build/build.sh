#!/bin/bash
echo
echo "✅  Building Etcher"
echo
git clone --recursive https://github.com/balena-io/etcher
cd etcher
git checkout v1.5.63
cd -
cp dissable-tiffutil.patch etcher/patches/
cd etcher
make electron-develop
make electron-build
echo "✅  Finished"
echo
