#!/bin/sh

SCRIPT=$(basename "$0")

if [ "$(ls .)" == $SCRIPT  ]; then
	
	echo "[BOOTSTRAP] bootstrapping website"
	hugo new site . --force
	echo

	echo "[BOOTSTRAP] ignore generated folders"
	echo "public" >> .gitignore
	git add .gitignore
	git commit -m "[GIT] ignored public folder"
	echo

	echo "[BOOTSTRAP] initialize the frontend branch"
	git checkout --orphan gh-pages
	git reset --hard
	git commit --allow-empty -m "[HUGO] gh-pages branch"
	git checkout master
	echo

	echo "[BOOTSTRAP] adding the vanilla theme"
	echo "theme = \"vanilla\"" >> config.toml
	git submodule add https://github.com/zwbetz-gh/vanilla-bootstrap-hugo-theme.git themes/vanilla
	git add . 
	git commit -m "[HUGO] added a theme"
	echo 

	echo "[BOOTSTRAP] add the correct base url"
	REMOTE_URL=$(git remote get-url origin)
	INFO_ARRAY=(${REMOTE_URL//[\/.]/ })	
	USER=${INFO_ARRAY[3]}
	REPO=${INFO_ARRAY[4]}
	BASE="https:\/\/${USER}.github.io\/${REPO}"
	sed -i '' "1s/.*/baseURL = \"$BASE\"/" config.toml
	git add . 
	git commit . -m "[HUGO] added base url"
	echo

	echo "[BOOTSTRAP] pushing to github"
	git push --all
	echo
	
else

	if [ "`git status -s`" ]
	then
	    echo "The working directory is dirty. Please commit any pending changes."
	    exit 1;
	fi

	echo "[DEPLOY] deleting old publication"
	rm -rf public
	mkdir public
	git worktree prune
	rm -rf .git/worktrees/public/
	echo

	echo "[DEPLOY] checking out gh-pages branch into public"
	git worktree add -B gh-pages public origin/gh-pages
	echo

	echo "[DEPLOY] removing existing files"
	rm -rf public/*
	echo

	echo "[DEPLOY] generating site"
	hugo
	echo

	echo "[DEPLOY] updating gh-pages branch"
	cd public && git add --all && git commit -m "[HUGO] deployed 2020-04-27"
	echo 

	echo "[DEPLOY] pushing to github"
	git push --all

fi
