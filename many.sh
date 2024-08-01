#!/bin/bash

newRemoteName=$1
newRemote=$2
pushToNewRemote=$3

directories=(
  .
  .
)

if [ $newRemoteName == "--help" ]; then
  echo -e "Usage: bash many.sh newRemoteName newRemoteUrl pushToNewRemote(optional, "y" or don't supply) \nEnsure you have populated the directories list prior to running.\nIf you intend to replace the CodeCommit remote, the newRemoteName is temporary and will be renamed to origin"
  exit 0
fi

for sourceDir in "${directories[@]}"; do
  bash main.sh $sourceDir $newRemoteName $newRemote $pushToNewRemote
  echo -e "\n\n"
done

echo "All directories have been migrated"