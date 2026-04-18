# bump2version-ci
Repository to host automated bump2version CI to run on python repositories

This action will bump package version on merge to a specified branch using bump2version on behalf of github-actions bot.
It will also automatically publish a new release on behalf of the user who created Personal Access Token

## Setup

### Add following workflow to your repository

```yaml
name: 'Bump2version-CI'
on:
  push:
    branches:
      - 'master'
      - 'main'

jobs:
  bump-version:
    runs-on: ubuntu-latest
    name: Bump version and push tags to master
    steps:
      - name: Bump version
        uses: Clinical-Genomics/bump2version-ci@v3
        env:
          BUMPVERSION_TOKEN: ${{ secrets.BUMPVERSION_TOKEN }}
          BUMPVERSION_AUTHOR: ${{ secrets.BUMPVERSION_AUTHOR }}
          BUMPVERSION_EMAIL: ${{ secrets.BUMPVERSION_EMAIL }}
          GITHUB_REPOSITORY: ${{ github.repository }}
          # Optional:
          # POST_BUMP_COMMAND: python -m cg.utils.changelog --update-existing CHANGELOG.md
```

### Add `.bumpversion.cfg` file to your repository


#### IMPORTANT! 
```
[skip ci] tag needs to be included in bumpversion commit message, otherwise the action will keep triggering itself indefinitely!  
```

#### Example bumpversion.cfg :
```
[bumpversion]
current_version = 0.0.0
commit = True
tag = True
tag_name = {new_version}
message = Bump version: {current_version} → {new_version} [skip ci] 

[bumpversion:file:setup.py]
[bumpversion:file:<package>/__init__.py]
```

### Set up Personal Access Token

* Go to `Account Settings / Developer settings / Personal access tokens` and 
create a new PAT
* Go to `Repository Setting / Secrets` and add the PAT as `BUMPVERSION_TOKEN`

### When installed in repository

* When pull request is ready to be merged, select "Squash and merge"
* Using the merge commit form, add the title and issue number of the pull request.
* Add mkdown formatted changelog as detailed commit message. 
* The commit message and formatting will be propagated towards the release.

## Optional post-bump hook

You can run an additional command after `bump2version` and before the action pushes the branch and tags
by setting the `POST_BUMP_COMMAND` environment variable.

If that command changes files in the repository, the action will:

* stage the changes
* amend the existing bump commit
* move any tags pointing at the bump commit to the amended commit

This is useful for tasks such as updating a generated changelog in the same release commit and tag.

Example:

```yaml
jobs:
  bump-version:
    runs-on: ubuntu-latest
    steps:
      - name: Bump version
        uses: Clinical-Genomics/bump2version-ci@v3
        env:
          BUMPVERSION_TOKEN: ${{ secrets.BUMPVERSION_TOKEN }}
          BUMPVERSION_AUTHOR: ${{ secrets.BUMPVERSION_AUTHOR }}
          BUMPVERSION_EMAIL: ${{ secrets.BUMPVERSION_EMAIL }}
          GITHUB_REPOSITORY: ${{ github.repository }}
          POST_BUMP_COMMAND: python -m cg.utils.changelog --update-existing CHANGELOG.md
```

