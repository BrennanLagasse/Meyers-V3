#!/bin/bash

# The following parameters are taken in by this bash script:
# 1. The directory to be pushed to the GitHub repository (this directory should be on the user's machine) (for example, for example /Users/william/Documents/Yale/Research/JobTesting2)
# 2. The https link to the GitHub repository (for example, https://github.com/wz2345/JobTesting2.git)
# 3. The GitHub access token (generated by going on GitHub to Settings --> Developer Settings --> Personal access tokens --> Tokens (classic) --> Generate new token --> Generate new token (classic) --> give repo and workflow scopes
# 4. Optional command line argument for the commit message when pushing to the GitHub repository, specified in single quotes. If not commit message is specified, an automatic one is generated by taking the current date and time at the time of the push


# Check if the directory is linked with a git repository
cd $1
if [ -d .git ]
then
# Update repository
	link=$(echo $2 | cut -c 9-)
	date=$(date)
	git pull https://$3@$link
	git add .
	# If there are only two command line arguments, generate the commit message
	# Otherwise, use the command line argument as the commit message
	if [ $# -eq 3 ]
	then
		git commit -m "New commit made on $date"
	else
		git commit -m "$4"
	fi
	git push https://$3@$link
else
# Create repository
	link=$(echo $2 | cut -c 9-)
	# Check git version
	if (echo a version 2.28.0; git --version) | sort -Vk3 | tail -1 | grep -q git
	then
		git init -b main
	else
		git init && git symbolic-ref HEAD refs/heads/main
	fi
	git add .
	if [ $# -eq 3 ]
	then
		git commit -m "First commit"
	else
		git commit -m "$4"
	fi
	git remote add origin https://$3@$link
	git remote -v
	git push -u origin main
fi