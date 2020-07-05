FROM jenkins/jenkins:alpine

# insall some plugins for jenkins, i am using jenkins to manage cronjobs
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/plugins.txt

USER root

RUN apk add docker
RUN apk add py-pip
RUN apk add python-dev libffi-dev openssl-dev gcc libc-dev make
RUN pip install docker-compose

USER jenkins