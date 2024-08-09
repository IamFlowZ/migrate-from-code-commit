#!/bin/bash

# The script is pretty simple. It takes two arguments: the source directory and the new origin. It then adds the new origin as a remote to the source directory and pushes all branches to the new origin. 
# After that, it asks if you want to replace the CodeCommit remote with the new origin. If you choose to replace it, the script will remove the CodeCommit remote and rename the new origin to origin. 
# To run the script, you can use the following command: 
# bash main.sh /path/to/source/directory

sourceDir=$1
newRemote=$2
newRemoteName=$3

$help="
Usage: bash main.sh /path/to/source/directory newRemoteUrl newRemoteName

newRemoteUrl - full url to new remote repository
newRemoteName - optional - name of the new remote. overwritten if you decide to set it to origin

You will be prompted to 
 - confirm the values before the script runs
 - confirm if you want to push to the new remote
 - confirm if you want to replace the CodeCommit remote with the new remote"

if [ $sourceDir == "--help" ]; then
  echo "$help"
  exit 0
fi

echo "Source directory: $sourceDir"
echo "New remote url: $newRemote"
echo "New remote name: $newRemoteName"

read -p "Do these values look correct? If so, press enter to continue. Otherwise, press ctrl+c to exit."

if [ -z "$sourceDir" ]; then
  echo "Source directory is required"
  exit 1
fi

if [ -z "$newRemote" ]; then
  echo "New remote is required"
  exit 1


if [ -z "$newRemoteName" ]; then
  newRemoteName="newRemote"
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

read -p "Would you like push to the new remote (y/n)?" choice1
echo ""
case "$choice1" in
  y|Y|yes ) push=1;;
  n|N|no ) push=0;;
  * ) echo "invalid";;
esac
if [ $push -eq 1 ]; then
  git push $newRemoteName --all
  echo "Pushed to $newRemote"
else
  echo "Not pushing to $newRemote"
fi

read -p "Would you like this to replace CodeCommit (y/n)?" choice
echo ""
case "$choice" in
  y|Y|yes ) replace=1;;
  n|N|no ) replace=0;;
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
