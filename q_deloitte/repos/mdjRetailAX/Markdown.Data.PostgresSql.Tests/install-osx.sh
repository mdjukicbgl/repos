#!/usr/bin/env bash
# Assume postgres, postgres dev headers and development tools are in path

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
  echo 'Error: git is not installed or in PATH.' >&2
  exit 1
fi

if ! [ -x "$(command -v cpanm)" ]; then
  echo 'Error: cpanm is not installed or in PATH. brew install cpanminus' >&2
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

# Install CPAN
echo -e "\n\nInstalling CPAN modules (pg_prove etc) via cpanm\n"
cpanm -n Module::Build TAP::Parser::SourceHandler::pgTAP TAP::Formatter::JUnit TAP::Harness::JUnit

# Install PgTap
echo -e "\n\nInstalling pgtap via git clone\n"
git clone https://github.com/theory/pgtap.git
pushd pgtap
make && make install
popd

# Install pg_tmp
echo -e "\n\nInstalling pg_tmp (empheralpg) via curl url\n"
mkdir ephemeralpg
pushd ephemeralpg
curl -O http://ephemeralpg.org/code/ephemeralpg-2.2.tar.gz
tar -C . --strip=1 -zxf ephemeralpg-2.2.tar.gz
make && make install
popd



