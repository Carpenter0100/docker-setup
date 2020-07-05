#!/usr/bin/env bash

OS=`uname -s`

if [ $OS != "Darwin" ]; then
  echo "This script is OSX-only. Please do not run it on any other Unix."
  exit 1
fi

if ! docker ps > /dev/null 2>&1 ; then
  echo "== Waiting for docker to start..."
fi

open -a Docker

while ! docker ps > /dev/null 2>&1 ; do sleep 2; done

osascript -e 'quit app "Docker"'

echo "== Resetting folder permissions..."
U=`id -u`
G=`id -g`
sudo chown -R "$U":"$G" .

echo "== Setting up nfs..."
LINE="/Users -alldirs -mapall=$U:$G localhost"
FILE=/etc/exports
sudo cp /dev/null $FILE
grep -qF -- "$LINE" "$FILE" || sudo echo "$LINE" | sudo tee -a $FILE > /dev/null

LINE="nfs.server.mount.require_resv_port = 0"
FILE=/etc/nfs.conf
grep -qF -- "$LINE" "$FILE" || sudo echo "$LINE" | sudo tee -a $FILE > /dev/null

echo "== Restarting nfsd..."
sudo nfsd restart

echo "== Restarting docker..."
open -a Docker

while ! docker ps > /dev/null 2>&1 ; do sleep 2; done

echo "SUCCESS! Now go run your containers 🐳"