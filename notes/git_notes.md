# GIT

[merge vs fast-forward](https://stackoverflow.com/questions/6701292/git-fast-forward-vs-no-fast-forward-merge)

## GitHub

REPOSITORY NEEDS TO EXIST ONLINE BEFORE TRYING TO PUSH TO IT.

## General merge guidelines

We want to resolve conflicts in the farthest branches from master.

ex:

- feature (y commits in front of dev)
- dev (x commits in front of feature, y commits behind)
- master

If we want to bring all x and y commits to master:

1) merge dev into feature (MAJ de feature), resolve conflits in feature, test final result
2) merge feature in dev (no merge conflict here)
3) merge master in dev, resolve conflicts in dev, test final result if applicable
4) merge dev in master (no merge conflict here)

ONLY DEV SHOULD MERGE INTO MASTER

## How to bring commits from rabyj to dev (while being in the rabyj branch)

~~~bash
git commit -m "commit message" # commit local chanches
git push  # push to remote
git checkout dev  # change to branch dev
git pull # update dev branch, pull remote changes
git merge --no-ff rabyj  # merge rabyj into dev, no fast forward
git push  # push local updated/merged branch to remote
git checkout rabyj  # move back to original branch
~~~

# git rm and its dangers

[How to revert a "git rm -r ."?](https://stackoverflow.com/questions/2125710/how-to-revert-a-git-rm-r/48628225#48628225)

~~~bash
# undo git rm
git rm file             # delete file & update index
git checkout HEAD file  # restore file & index from HEAD

# undo git rm -r
git rm -r dir          # delete tracked files in dir & update index
git checkout HEAD dir  # restore file & index from HEAD

# undo git rm -rf
git rm -rf dir          # delete tracked files & delete uncommitted changes
not possible           # `uncommitted changes` can not be restored.

# LAST RESORT
git prune -n
git cat-file -p <blob #>
~~~

Uncommitted changes includes not staged changes, staged changes but not committed.

## Other commands

~~~bash
# other
git diff --staged # see changes from "git add" but non commited
git fetch --all --prune # find new/rm remote branches
git log --graph --decorate --oneline --all #see branches tree

# reseting
git reset --soft HEAD~1 # move back one commit while retaining local changes
git reset --hard HEAD~1 # move back one commit while discarding local changes
git reset [option] HEAD@{1} #move forward one commit with option.

# stash
git stash list #list existing stashes
git stash push -m "my_stash" # save a named stash, brings all working directory changes to stash
git stash pop "stash@{n}" # apply a stash and remove it from the stash list
git stash apply "stash@{n}" # apply a stash and keep it in the stash cache

# working on multiple branches at same time
git worktree add <path> [<branch>] # Create <path> and checkout <branch> into it. The new working directory is linked to the current repository, sharing everything except working directory specific files such as HEAD, index, etc.
~~~

## How do I delete a Git branch locally and remotely?

<https://stackoverflow.com/questions/2003505/how-do-i-delete-a-git-branch-locally-and-remotely>

~~~bash
# delete local branch
git branch -D branch_name #-D forces deletion, use -d otherwise, need to have HEAD on different branch

# delete remote branch
git push <remote_name> --delete <branch_name> # <remote_name> usually origin
~~~

## How to modify source of a git (e.g. fork)

<https://stackoverflow.com/questions/11619593/how-to-change-the-fork-that-a-repository-is-linked-to>

~~~bash
git remote set-url origin git@github.com:<USER>/<GITNAME>.git #modify origin tracking
git branch --set-upstream-to=origin/<branch> <branch> # for each branch, if they keep the same name. or use thefuck
~~~

## GITLAB

Link each commit (and merge) with the correct issue ('ref #123' or '!123' in commit message)
<https://about.gitlab.com/2016/03/08/gitlab-tutorial-its-all-connected/>

Crée de merge requests pour tous les changements pour que je puisse commenter et approuver.