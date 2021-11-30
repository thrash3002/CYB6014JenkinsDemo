#!/bin/bash

# these can remain as is to use the generic version
# alternatively, fork from this project to modify and include
# prebuild jenkins build pipelines etc, and then change these variables to match
jenkinsGitPath="https://github.com/thrash3002/CYB6014JenkinsDemo.git"
jenkinsFolderName="CYB6014JenkinsDemo"

# change these variables to point to your own projects as necessary
# NOTE: project must contain a Dockerfile
projectGitPath="https://github.com/thrash3002/CYB6014Sample.git"
projectFolderName="CYB6014Sample"
projectBranch="demo"

exitCode=0

if [ "$1" = '--stop' ]; then
	echo "stopping and removing containers"
	cd $jenkinsFolderName
	docker-compose down
	echo "containers have been removed"
else
	echo "cleaning workspace"
	rm -rf $jenkinsFolderName
	echo "workspace cleaned"
	echo ""
	echo ""
	echo ""
	
	# clone jenkins project from git
	echo "cloning jenkins project"
	git clone $jenkinsGitPath
	cd $jenkinsFolderName
	echo ""
	echo ""
	echo ""
	
	# clone test project from git
	echo "cloning test project"
	mkdir project
	cd project
	git clone -b $projectBranch $projectGitPath
	cp -r $projectFolderName/* .
	rm -rf $projectFolderName
	echo "press any key to continue"
	read

	echo ""
	echo ""
	echo ""


	# spin up docker containers
	echo "Spinning up containers"
	docker-compose up --build -d

	#store the  exit status of the previous line in the result  variable
	result=$?

	#new line
	echo ""
	echo ""
	echo ""

	#set the return code to default to 1 - i.e. something has gone wrong
	exitCode=1

	if [ 0 -eq $result ]; then
		echo "Setup is complete."
		echo "Navigate to each of the following to see that the basic webpage is up:"
		echo "   - archery:     http://localhost:8000"
		echo "   - jenkins:     http://localhost:8080 (note that Jenkins can take some time to come up)"
		echo "   - OWASP ZAP:   http://localhost:8090"
		echo "   - project:     http://localhost:5000"
		
		echo "Please log onto jenkins and configure your build pipeline."
		echo "The jenkins pipeline can access scripts on the ZAP container directly by passing script commands to 'ssh -o StrictHostKeyChecking=no anonymous@zap'"

		exitCode=0
	else
		echo "Setup failed.  Please check the output."
	fi
fi
exit $exitCode