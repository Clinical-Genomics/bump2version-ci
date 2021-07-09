#!/bin/bash

set -eox pipefail

REPOSITORY="https://github.com/${GITHUB_REPOSITORY}.git"
echo "Cloning ${REPOSITORY}"
VERSION="patch"

git clone "${REPOSITORY}"
cd "$(ls)" || exit

git config --global user.email "you@example.com"
git config --global user.name "Your Name"
bump2version --config-file .bumpversion.cfg "${VERSION}"
git push https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git
git push https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git --tags





