#!/bin/bash
# version.sh
VERSION="0.0.1"

# handle --version option
if [ "$1" == "--version" ]; then
  print_version
fi

function print_version {
  echo "Version: $VERSION"
  exit 0
}

