#!/bin/bash
# Package Etcher

arch=`dpkg --print-architecture`
version=""
echo
echo "✅  Check System"
get_version ()
{
  # rm builder-effective-config.json
  # create json from yaml
  python -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=4)' < etcher/dist/builder-effective-config.yaml > builder-effective-config.json
  version=$(cat builder-effective-config.json | jq -r '.extraMetadata.version')
  echo "etcher version = $version"
}
update_control ()
{
  # updating control file
  sed -i "s/#\?\(Version:\s*\).*$/\1$version/" balena-etcher-electron_$version\_$os\_$dist\_$arch/DEBIAN/control
  sed -i "s/#\?\(Architecture:\s*\).*$/\1$arch/" balena-etcher-electron_$version\_$os\_$dist\_$arch/DEBIAN/control
}
detect_os ()
{
  if [[ ( -z "${os}" ) && ( -z "${dist}" ) ]]; then
    # some systems dont have lsb-release yet have the lsb_release binary and
    # vice-versa
    if [ -e /etc/lsb-release ]; then
      . /etc/lsb-release

      if [ "${ID}" = "raspbian" ]; then
        os=${ID}
        dist=`cut --delimiter='.' -f1 /etc/debian_version`
      else
        os=${DISTRIB_ID}
        dist=${DISTRIB_CODENAME}

        if [ -z "$dist" ]; then
          dist=${DISTRIB_RELEASE}
        fi
      fi

    elif [ `which lsb_release 2>/dev/null` ]; then
      dist=`lsb_release -c | cut -f2`
      os=`lsb_release -i | cut -f2 | awk '{ print tolower($1) }'`

    elif [ -e /etc/debian_version ]; then
      # some Debians have jessie/sid in their /etc/debian_version
      # while others have '6.0.7'
      os=`cat /etc/issue | head -1 | awk '{ print tolower($1) }'`
      if grep -q '/' /etc/debian_version; then
        dist=`cut --delimiter='/' -f1 /etc/debian_version`
      else
        dist=`cut --delimiter='.' -f1 /etc/debian_version`
      fi

    else
      unknown_os
    fi
  fi

  if [ -z "$dist" ]; then
    unknown_os
  fi

  # remove whitespace from OS and dist name
  os="${os// /}"
  dist="${dist// /}"

  echo "Detected operating system as $os/$dist/$arch"
}

detect_os
get_version

echo 
echo "✅  Packaging Resources"

rm -rf balena-etcher-electron_$version\_$os\_$dist\_$arch*
cp -r default_deb_package balena-etcher-electron_$version\_$os\_$dist\_$arch
update_control
mkdir balena-etcher-electron_$version\_$os\_$dist\_$arch/opt
cp -r etcher/dist/linux-armv7l-unpacked balena-etcher-electron_$version\_$os\_$dist\_$arch/opt/balenaEtcher
echo
echo "✅  Building Package"
dpkg-deb -b balena-etcher-electron_$version\_$os\_$dist\_$arch
echo "✅  Packaging Finished"
