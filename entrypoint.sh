#!/bin/bash

# Requiered env vars:

# GITHUB_TOKEN: 
# GITHUB_REPOSITORY: 
# GITHUB_ACTOR: 

# INPUT_RELEASE_PAT:




set -eo pipefail

REPOSITORY="https://github.com/${GITHUB_REPOSITORY}.git"

git clone "${REPOSITORY}"
cd "$(ls)" || exit

# Fetching the commit messages for the current branch??
COMMIT_MSG=$(git log -1 --pretty=%B)

# Parsing patch
if [[ $COMMIT_MSG == *'major'* ]]; then
  VERSION='major';
elif [[ $COMMIT_MSG == *'minor'* ]]; then
  VERSION='minor';
else
  VERSION='patch';
fi

# What is this? 41898282+github-actions[bot]@users.noreply.github.com
# Configuring ... wat?
# Bumping and pushing
# Why pulling?
git config --global user.email "41898282+github-actions[bot]@users.noreply.github.com"
git config --global user.name "Github CI"
bump2version --config-file .bumpversion.cfg "${VERSION}"
git push https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git
git push https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git --tags
git pull

# Fetching new tag ?? and releasing it using the PAT of whom? 
NEW_TAG="$(git describe)" 
POST_DATA=$(echo {\"tag_name\": \"$NEW_TAG\", \"name\": \"Release $NEW_TAG\", \"draft\": false, \"prerelease\": false})
echo "Submitting release for $NEW_TAG"
curl \
  -X POST \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token $INPUT_RELEASE_PAT" \
  -d "$POST_DATA" \
  "https://api.github.com/$GITHUB_REPOSITORY/releases"






