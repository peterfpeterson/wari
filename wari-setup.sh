#!/bin/sh

get_script_dir () {
     SOURCE="${BASH_SOURCE[0]}"
     # While $SOURCE is a symlink, resolve it
     while [ -h "$SOURCE" ]; do
          DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
          SOURCE="$( readlink "$SOURCE" )"
          # If $SOURCE was a relative symlink (so no "/" as prefix, need to resolve it relative to the symlink base directory
          [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
     done
     DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
     echo "$DIR"
}

WARI_ROOT=$(get_script_dir)

# Now let's determine what distro we are running on.
if [ -f "/etc/os-release" ]; then
  . /etc/os-release
  WARI_DISTRO=$ID
  WARI_DISTRO_VERSION=$VERSION_ID
else
  echo "/etc/os-release not available - your distro is too old! Upgrade! :-)"
  exit -1
fi

if [ -f "$WARI_ROOT/wari-repos" ]; then
  source $WARI_ROOT/wari-repos
else
  echo "Did not find 'wari-repos'...skipping"
fi
source $WARI_ROOT/wari-addrepo-yum.sh $WARI_REPOS

if [ -f "$WARI_ROOT/wari-packages" ]; then
  source $WARI_ROOT/wari-packages
else
  echo "Did not find 'wari-packages'...skipping"
fi
source $WARI_ROOT/wari-addpackages.sh $WARI_PACKAGES
