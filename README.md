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


