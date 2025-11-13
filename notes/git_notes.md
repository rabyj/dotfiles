# GIT

[merge vs fast-forward](https://stackoverflow.com/questions/6701292/git-fast-forward-vs-no-fast-forward-merge)

## GitHub

REPOSITORY NEEDS TO EXIST ONLINE BEFORE TRYING TO PUSH TO IT.

Find watched issues and such (subscriptions): <https://github.com/notifications/subscriptions>

Find comments by me: <https://github.com/search?q=is%3Aissue+commenter%3A%40me&type=issues>

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

DO NOT SQUASH FEATURE BRANCHES, YOU LOSE COMMIT HISTORY CONNECTIONS (only ok for a very small amount of redundant commits)

## How to bring commits from rabyj to dev (while being in the rabyj branch)

```bash
git commit -m "commit message" # commit local chanches
git push  # push to remote
git checkout dev  # change to branch dev
git pull # update dev branch, pull remote changes
git merge --no-ff rabyj  # merge rabyj into dev, no fast forward
git push  # push local updated/merged branch to remote
git checkout rabyj  # move back to original branch
```

## tags

When you push your tags to a remote repository using git push --follow-tags, only the annotated tags will be pushed.

```bash
git tag -a v1.5 -m "Release v1.5 created"
git push origin <tag_name> # push single tag
git push --tags # push all tags
git config --global push.followTags true # change the setting
git tag --delete tagname # delete local tag
git push origin :refs/tags/tagname # delete remote tag

# Refresh all tags (sync local w remote), https://stackoverflow.com/questions/1841341/remove-local-git-tags-that-are-no-longer-on-the-remote-repository
git tag -l | xargs git tag -d # rm all tags
git fetch --tags
```

## Recover lost commits / discarded changes

Ways to recover commits or working changes that were lost due to various git operations (reset, rebase, etc).

### Undoing a git rebase

<https://stackoverflow.com/questions/134882/undoing-a-git-rebase>
Permalink: <https://stackoverflow.com/q/134882>
Summary: Use git reflog (reference log) to find the commit hash before the rebase, then reset to it.

### git rm and its dangers

[How to revert a "git rm -r ."?](https://stackoverflow.com/questions/2125710/how-to-revert-a-git-rm-r/48628225#48628225)
Permalink: <https://stackoverflow.com/q/212571>

```bash
# Removes from tracked files, but do not affect file on disk
# Will add the delete action of the file to the index
# On commit the file will be removed from the HEAD commit
git rm --cached file

# undo git rm
git rm file             # delete file & update index
git checkout HEAD file  # restore file & index from HEAD

# undo git rm -r
git rm -r dir          # delete tracked files in dir & update index
git checkout HEAD dir  # restore file & index from HEAD

# undo git rm -rf
git rm -rf dir          # delete tracked files & delete uncommitted changes
not possible           # `uncommitted changes` can not be directly restored
```

Uncommitted changes include:

- not staged changes (git add not done)
- staged changes but not committed (git add but not git commit)

### Recover from accidental reset of working changes

Changes that were previously staged or stashed can be recovered using `git fsck --lost-found`, even if accidentally discarded.
This last command finds dangling objects and places them in `.git/lost-found/`. Use `git cat-file -p <SHA>` to view content. (p=print)

Turn off automatic garbage collection if more time is needed for the recovery process: `git config --global gc.auto 0`

Alternatively, `git prune -n` shows files subject to garbage collection without actually deleting them. This allows targeted recovery.

```bash
# 1. See what's unreachable (don't delete yet!)
git prune -n

# 2. Investigate interesting SHAs
git cat-file -p <SHA>
git cat-file -t <SHA>  # check type: blob, commit, tree

# 3. If you find your lost content, recover it
git cat-file -p <SHA> > recovered_file.txt
```

Maybe send each one into a tmp file in a tmp directory for easier viewing (would be easy to automate).

### Recover discarded working changes in VSCode

In addition, vscode timeline may help recover changes if vscode was used to edit the files.
<https://stackoverflow.com/questions/43541167/how-do-you-undo-discard-all-changes-in-vs-code-git/77093855#77093855>
Permalink: <https://stackoverflow.com/a/77093855>

Use ctrl+P to see recently opened files.
Use ctrl+R to see recently opened non-project files/folders.

## Commit signature

Set up gpg signature for commits/tags ([reference](https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key)):

To sign tags/commits by default, put `commit.gpgSign` and `tag.gpgSign` to true.

To sign a single commit/tag:

```bash
git commit -S -m "my signed commit"
git tag -s v1.0 -m "my signed tag"
```

To rebase and sign all commits after `<base-commit>` ([source](https://superuser.com/questions/397149/can-you-gpg-sign-old-commits)):

```bash
git rebase --exec 'git commit --amend --no-edit -n -S' -i <base-commit>
```

## Other commands

```bash
# info collectiong
git diff --staged # see changes from "git add" but non commited
git diff --stat --summary [from commit1] [to commit2] # See diff as you would in a fast-forward merge/pull
git diff --stat --summary origin/rabyj HEAD # what would be pushed
git log --graph --decorate --oneline --all #see branches tree

# Update branches
git fetch --all --prune # find new/rm remote branches

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

git rebase --interactive [new base commit, commit is not included in rebasing]
```

## How do I delete a Git branch locally and remotely?

<https://stackoverflow.com/questions/2003505/how-do-i-delete-a-git-branch-locally-and-remotely>

```bash
# delete local branch
git branch -D branch_name #-D forces deletion, use -d otherwise, need to have HEAD on different branch

# delete remote branch
git push <remote_name> --delete <branch_name> # <remote_name> usually origin
```

## How to modify source of a git (e.g. fork)

<https://stackoverflow.com/questions/11619593/how-to-change-the-fork-that-a-repository-is-linked-to>

```bash
git remote set-url origin git@github.com:<USER>/<GITNAME>.git #modify origin tracking
git branch --set-upstream-to=origin/<branch> <branch> # for each branch, if they keep the same name
```

## GITLAB

Link each commit (and merge) with the correct issue ('ref #123' or '!123' in commit message)
<https://about.gitlab.com/2016/03/08/gitlab-tutorial-its-all-connected/>

Crée de merge requests pour tous les changements pour que je puisse commenter et approuver.

## GitKraken

Compare two arbitrary commits: shift+click on each commit. gitlens also lets you do that in a more complex way.
