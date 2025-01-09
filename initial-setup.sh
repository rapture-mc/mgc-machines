#!/run/current-system/sw/bin/bash

if [ $# -ne 1 ]; then
  echo "You must supply at least one argument (the hostname)"
  exit 1
fi

echo "Cloning git directory to /tmp/mgc-machines"
git clone https://github.com/rapture-mc/mgc-machines /tmp/mgc-machines

cd /tmp/mgc-machines

git checkout dev

echo "Running nh os switch..."
nh os switch . -H $1
