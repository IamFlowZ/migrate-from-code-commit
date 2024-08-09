#!/bin/bash

$help=$1
$helpText="
Usage: bash many.sh
This script will run main.sh for each directory in the directories array. Pairing information with the remotes array at the same index.
You do still have to answer the questions for each directory, but this script will automate the process of running main.sh for each directory."

directories=(
  .
  .
)

remotes=(
  ''
  ''
)

if [ $help == "--help" ]; then
  echo -e "Usage: bash many.sh"
  exit 0
fi

for index in "${!directories[@]}"; do
  bash main.sh ${directories[$index]} ${remotes[$index]}
  echo -e "\n\n"
done

echo "All directories have been migrated"