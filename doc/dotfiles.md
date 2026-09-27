# How to clone dotfiles on new machine

This approach have you structuring your dotfiles repository relative to your
home directory, and keeping a one-byte `*` in `.gitignore`.

Example dotfiles repo:

```
$ ls -A
.config/
.git/
.gitignore
.profile
bin/
```

To add new files/directories:

```
git add -f file.conf
git add -f some/dir/
```

Cloning on new machine:

```
cd ~
rm -rf .git
git init -b master
git remote add origin git@github.com:Sathu03/dotfiles
git fetch --all
git switch -f master
```
