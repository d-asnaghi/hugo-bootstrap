#!/bin/sh

SCRIPT=`basename "$0"`

if [ "$(ls .)" == $SCRIPT  ]; then
	
	echo "[HUGO] bootstrapping website"
	hugo new site . --force
	git init
	echo

	echo "[HUGO] ignore generated folders"
	echo "public" >> .gitignore
	git add .gitignore
	git commit -m "[GIT] ignored public folder"
	echo

	echo "[HUGO] initialize the frontend branch"
	git checkout --orphan gh-pages
	git reset --hard
	git commit --allow-empty -m "[HUGO] gh-pages branch"
	git checkout master
	echo

	echo "[HUGO] adding the vanilla theme"
	git submodule add https://github.com/zwbetz-gh/vanilla-bootstrap-hugo-theme.git themes/vanilla
	git add . 
	git commit -m "[HUGO] added a theme"
	echo 

fi


if [ "`git status -s`" ]
then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out gh-pages branch into public"
git worktree add -B gh-pages public origin/gh-pages

echo "Removing existing files"
rm -rf public/*

echo "Generating site"
hugo

echo "Updating gh-pages branch"
cd public && git add --all && git commit -m "[HUGO] deployed 2020-04-27"

echo Pushing to github
# git push --all
hugo server
