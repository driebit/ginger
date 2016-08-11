Releases
========

This is how we manage Ginger releases.

1. Five working days before a release, create a release branch from the `master`
   branch called `release-0.x.0` (e.g. `release-0.14.0`). 

2. Regular development will continue on `master`. Any hotfixes that should make 
   it in the release must first be pushed to `master` and then cherry-picked in
   the release branch:
   
   ```bash
   $ git checkout master
   $ git pull
   $ git checkout release-0.14.0
   $ git cherry-pick [commit hash]
   $ git push
   ```
   
3. On release day (preferably the first Monday of the month in tandem with
   [Zotonic’s releases](http://zotonic.com/docs/latest/developer-guide/contributing.html#zotonic-releases))
   tag the release branch and then discard it:
   
   ```bash
   $ git checkout release-0.14.0
   $ git pull
   $ git tag 0.14.0
   $ git push origin 0.14.0
   $ git checkout master
   $ git branch -d release-0.14.0
   $ git push origin :release-0.14.0
   ```
