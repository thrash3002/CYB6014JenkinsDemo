FROM jenkins/jenkins:lts

ARG NET_CORE_APP_NAME=netcoreapp

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

USER root

RUN \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install --quiet --yes --fix-missing \
    python3-pip \
    ruby-full \
    jq

# download archery into container
RUN pip install archerysec-cli
RUN apt-get install jq

# copy plugins to jenkins directory
COPY plugins.txt /usr/share/jenkins/plugins.txt

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

# cleanup of installation scripts
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /var/dockerscripts




# create new archery project
#RUN archerysec-cli \
#    -s http://127.0.0.1:8000 \
#    -u admin \
#    -p password \
#    --createproject \
#    --project_name=test_project \
#    --project_disc="test project"
	
# run archery scan
#RUN archerysec-cli \ 
#    -s http://127.0.0.1:8000 \
#    -u admin \
#    -p password \
#    --zapscan \
#    --target_url=http://demo.testfire.net \
#    --project_id=8b4303bc-2cd6-4212-8801-231e8b10be4d

#archerysec-cli -h http://127.0.0.1:8000 --zap-full-scan --target http://demo.testfire.net --cicd_id 1234