#!/usr/bin/env bash
# Assume postgres, postgres dev headers and development tools are in path

INSTALL_CMD="sudo apt-get install git cpanminus postgresql-9.5 postgresql-client-9.5  postgresql-contrib-9.5 postgresql-9.5-pgtap libtap-formatter-junit-perl"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

if ! [ -x "$(command -v cc)" ]; then
  echo 'Error: cc is not installed or in PATH.' >&2
  exit 1echo
fi

if ! [ -x "$(command -v curl)" ]; then
  echo 'Error: curl is not installed or in PATH.' >&2
  exit 1
fi

if ! [ -x "$(command -v git)" ]; then
  echo -e "Error: git is not installed or in PATH. Install dependancies with: $INSTALL_CMD" >&2
  exit 1
fi

if ! [ -x "$(command -v cpanm)" ]; then
  echo -e "Error: cpanm is not installed or in PATH. Install dependancies with: $INSTALL_CMD" >&2
  exit 1
fi

if ! [ -x "$(command -v pg_config)" ]; then
  echo 'Error: postgres binaries are not installed or in PATH. brew install postgresql' >&2
  exit 1
fi

scratch=$(mktemp -d -t tmp.XXXXXXXXXX)
pushd $scratch
function finish {
  rm -rf "$scratch"
  popd
}
trap finish EXIT

echo -e "\n\nInstalling CPAN modules (TAP::Harness::JUnit) via cpanm\n"
cpanm -n TAP::Harness::JUnit

# Install pg_tmp
echo -e "\n\nInstalling pg_tmp (empheralpg) via curl url\n"
mkdir ephemeralpg
pushd ephemeralpg
curl -O http://ephemeralpg.org/code/ephemeralpg-2.2.tar.gz
tar -C . --strip=1 -zxf ephemeralpg-2.2.tar.gz
make && make install
popd

