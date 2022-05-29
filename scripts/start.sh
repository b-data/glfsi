#!/bin/bash
# Copyright (c) 2022 b-data GmbH.
# Distributed under the terms of the MIT License.

set -e

cd /tmp
curl -sSLO https://github.com/git-lfs/git-lfs/releases/download/v${GIT_LFS_VERSION}/git-lfs-linux-$(dpkg --print-architecture)-v${GIT_LFS_VERSION}.tar.gz
tar xfz git-lfs-linux-$(dpkg --print-architecture)-v${GIT_LFS_VERSION}.tar.gz --no-same-owner
cd git-lfs-${GIT_LFS_VERSION}

sed -i 's/git lfs install/#git lfs install/g' install.sh
echo '
mkdir -p $prefix/share/man/man1
rm -rf $prefix/share/man/man1/git-lfs*

pushd "$( dirname "${BASH_SOURCE[0]}" )/man/man1" > /dev/null
  for g in git-lfs*; do
    install -m0644 $g "$prefix/share/man/man1/$g"
  done
popd > /dev/null

mkdir -p $prefix/share/man/man5
rm -rf $prefix/share/man/man5/git-lfs*

pushd "$( dirname "${BASH_SOURCE[0]}" )/man/man5" > /dev/null
  for g in git-lfs*; do
    install -m0644 $g "$prefix/share/man/man5/$g"
  done
popd > /dev/null' >> install.sh

echo '#!/usr/bin/env bash
set -eu

prefix="/usr/local"

if [ "${PREFIX:-}" != "" ] ; then
  prefix=${PREFIX:-}
elif [ "${BOXEN_HOME:-}" != "" ] ; then
  prefix=${BOXEN_HOME:-}
fi

rm -rf $prefix/bin/git-lfs*
rm -rf $prefix/share/man/man1/git-lfs*
rm -rf $prefix/share/man/man5/git-lfs*' > uninstall.sh
chmod +x uninstall.sh

if [[ -f "${MODE}.sh" ]]; then
  ./${MODE}.sh
  echo "Git LFS at ${PREFIX} ${MODE}ed."
else
  echo "Execution mode '${MODE}' not supported!"
fi
