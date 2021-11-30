FROM jenkins/jenkins:lts

ARG NET_CORE_APP_NAME=netcoreapp

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
ENV JENKINS_HOME /var/jenkins_home

USER root

# copy plugins to jenkins directory
COPY plugins.txt /usr/share/jenkins/plugins.txt

# create the jenkins job directory and copy the job configuration
RUN mkdir -p "$JENKINS_HOME/jobs/${NET_CORE_APP_NAME}"
COPY "$NET_CORE_APP_NAME".xml "$JENKINS_HOME/jobs/$NET_CORE_APP_NAME/config.xml"
RUN chown -R jenkins "$JENKINS_HOME/jobs"

# create temporary scripts folder
RUN mkdir -p /var/dockerscripts

# sudo is required for running command in elevation
COPY installsudo.sh /var/dockerscripts/
RUN /bin/bash -c "source /var/dockerscripts/installsudo.sh"

# curl is required for downloading external packages
COPY installcurl.sh /var/dockerscripts/
RUN /bin/bash -c "source /var/dockerscripts/installcurl.sh"

# # scm packages are required for git support in jenkins
COPY installscmpackages.sh /var/dockerscripts/
RUN /bin/bash -c "source /var/dockerscripts/installscmpackages.sh"

# install all required jenkins plugins, like pipeline support, etc
COPY installjenkinsplugins.sh /var/dockerscripts/
RUN /bin/bash -c "source /var/dockerscripts/installjenkinsplugins.sh"

#install dotnet core sdk - required for building, testing, and publishing dotnetcore projects
#(NOTE: these are not needed unless specifically running dotnet commands within jenkins 
#instead of the project container)
#COPY installnetcoresdk.sh /var/dockerscripts
#RUN /bin/bash -c "source /var/dockerscripts/installnetcoresdk.sh"

# cleanup of installation scripts
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /var/dockerscripts

# install python to be able to run Archery CLI in container
RUN \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install --quiet --yes --fix-missing \
    python3-pip \
    ruby-full \
    jq
	
# Install Archery CLI into container
RUN pip install archerysec-cli
