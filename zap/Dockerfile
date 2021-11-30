FROM owasp/zap2docker-stable

USER root

# create temporary scripts folder
RUN mkdir -p /var/dockerscripts

# sudo is required for running command in elevation
COPY installsudo.sh /var/dockerscripts/
RUN /bin/bash -c "source /var/dockerscripts/installsudo.sh"

# curl is required for downloading external packages
COPY installcurl.sh /var/dockerscripts/
RUN /bin/bash -c "source /var/dockerscripts/installcurl.sh"


# cleanup of installation scripts
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /var/dockerscripts

RUN apt-get update && yes | apt-get install apt-utils

#instal ssh server
RUN apt-get update && apt-get install -y netcat ssh iputils-ping 
RUN apt-get update && apt-get install -y openssh-server

#allow anonymous user ssh session
RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication/PasswordAuthentication/' /etc/ssh/sshd_config
RUN echo "Match user anonymous\n   PermitEmptyPasswords yes" >> /etc/ssh/sshd_config
RUN adduser --disabled-password anonymous
RUN sed -i -re 's/^anonymous:[^:]+:/anonymous::/' /etc/passwd /etc/shadow
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN sed -i 's/@include common-auth/auth [success=1 default=ignore] pam_unix.so nullok\nauth requisite pam_deny.so\nauth required pam_permit.so/' /etc/pam.d/sshd

ENTRYPOINT service ssh start && zap.sh -daemon -host 0.0.0.0 -port 8090 -config api.disablekey=true -config api.addrs.addr.name=.* -config api.addrs.addr.regex=true