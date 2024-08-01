#!/bin/bash

# The script is pretty simple. It takes two arguments: the source directory and the new origin. It then adds the new origin as a remote to the source directory and pushes all branches to the new origin. 
# After that, it asks if you want to replace the CodeCommit remote with the new origin. If you choose to replace it, the script will remove the CodeCommit remote and rename the new origin to origin. 
# To run the script, you can use the following command: 
# bash main.sh /path/to/source/directory

sourceDir=$1
newRemoteName=$2
newRemote=$3
pushToNewRemote=$4

if [ $sourceDir == "--help" ]; then
  echo -e "Usage: bash main.sh /path/to/source/directory newRemoteName newRemoteUrl pushToNewRemote(optional, "y" or don't supply) \nIf you intend to replace the CodeCommit remote, the newRemoteName is temporary and will be renamed to origin"
  exit 0
fi

echo "Source directory: $sourceDir"
echo "New remote name: $newRemoteName"
echo "New remote url: $newRemote"
echo "Push to new remote: $pushToNewRemote"

read -p "Do these values look correct? If so, press enter to continue. Otherwise, press ctrl+c to exit."

if [ -z "$sourceDir" ]; then
  echo "Source directory is required"
  exit 1
fi

if [ -z "$newRemote" ]; then
  echo "New remote is required"
  exit 1
fi

if [ ! -d "$sourceDir" ]; then
  echo "Source directory does not exist"
  exit 1
fi

if [ ! -d "$sourceDir/.git" ]; then
  echo "Source directory is not a git repository"
  exit 1
fi

echo -e "Warning: prior to running, ensure that...\nall local branches on ALL machines have been pushed to the CodeCommit remote\nYou have fetched the codecommit remote\nYou have the correct permissions to push to the new remote\n"
read -p "If you have done so, press enter to continue. Otherwise, press ctrl+c to exit."

cd $sourceDir

git fetch origin

git remote add $newRemoteName $newRemote

echo "Remote $newRemoteName added with url $newRemote"

if [[ $pushToNewRemote == "y" || $pushToNewRemote == "Y" ]];then
  echo "Pushing new remote..."
  git push $newRemoteName --all
fi

read -p "Would you like this to replace CodeCommit (y/n)?" choice
echo ""
case "$choice" in
  y|Y ) replace=1;;
  n|N ) replace=0;;
  * ) echo "invalid";;
esac

if [ $replace -eq 1 ]; then
  git remote rm origin
  git remote rename $newRemoteName origin
  echo "CodeCommit remote replaced with $newRemote"
else
  echo "CodeCommit remote not replaced"
fi

echo -e "Final steps:\n 1. Ensure that the new remote is added to all local repositories\n 2. Ensure that all local branches are pushed to the new remote\n 3. Ensure that the CodeCommit remote is removed from all local repositories\n 4. Ensure that the new remote is renamed to origin in all local repositories\n"


echo "Finished updating $sourceDir"
