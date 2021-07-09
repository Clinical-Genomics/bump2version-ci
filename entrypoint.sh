#!/bin/bash

set -eo pipefail

REPOSITORY="https://github.com/${GITHUB_REPOSITORY}.git"
VERSION="patch"

git clone "${REPOSITORY}"
cd "$(ls)" || exit

git config --global user.email "you@example.com"
git config --global user.name "Github CI"
bump2version --config-file .bumpversion.cfg "${VERSION}"
git push https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git
git push https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git --tags





