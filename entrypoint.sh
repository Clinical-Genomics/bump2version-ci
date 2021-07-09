#!/bin/bash

set -eo pipefail

REPOSITORY="https://github.com/${GITHUB_REPOSITORY}.git"

git clone "${REPOSITORY}"
cd "$(ls)" || exit

COMMIT_MSG=$(git log -1 --pretty=%B)

if [[ $COMMIT_MSG == *'major'* ]]; then
  VERSION='major';
elif [[ $COMMIT_MSG == *'minor'* ]]; then
  VERSION='minor';
else
  VERSION='patch';
fi

git config --global user.email "maryia.ropart@scilifelab.se"
git config --global user.name "Github CI"
bump2version --config-file .bumpversion.cfg "${VERSION}"
git push https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git
git push https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git --tags





