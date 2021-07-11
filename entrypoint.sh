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

git config --global user.email "41898282+github-actions[bot]@users.noreply.github.com"
git config --global user.name "Github CI"
bump2version --config-file .bumpversion.cfg "${VERSION}"
git push https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git
git push https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git --tags
git pull

NEW_TAG="$(git describe)"
POST_DATA="{'tag_name': '$NEW_TAG', 'name': 'Release $NEW_TAG', 'draft': 'false', 'prerelease': 'false'}"

echo "Submitting release for $NEW_TAG"
echo $POST_DATA
curl \
  -X POST \
  -H "Accept: application/vnd.github.v3+json" \
  -d "$POST_DATA" \
  "https://api.github.com/repos/$GITHUB_REPOSITORY/releases?access_token=$GITHUB_TOKEN"






