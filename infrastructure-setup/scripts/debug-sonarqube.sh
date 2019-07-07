#!/usr/bin/env bash

export PATH=$PATH:/usr/local/bin/
BASE_DIR=${OPENDEVSTACK_BASE_DIR:-"/ods"}

. ${BASE_DIR}/local.env.config

cwd=${pwd}

if [ "$HOSTNAME" != "openshift" ] ; then
	echo "This script has to be executed on the openshift VM"
	exit
fi

oc login -u system:admin
oc project cd
cd /ods/ods-core/sonarqube/ocp-config
oc get pods 

# oc describe build docker-build
# docker logs docker-build
echo "oc describe pod jenkins-master-1-build"
oc describe pod jenkins-master-1-build

echo "oc logs jenkins-master-1-build -c git-clone"
oc logs jenkins-master-1-build -c git-clone

echo "oc start-build from archive"
oc start-build --from-archive=docker-build.tar --loglevel=10 forum-s2i --follow



oc logs jenkins-master-1-build
oc logs jenkins-master-2-build
oc logs jenkins-slave-base-1-build
oc logs jenkins-webhook-proxy-1-build


oc logs nexus3-1-mxncx 


oc logs sonarqube-1-build
oc logs sonarqube-2-build 
oc logs sonarqube-3-build 
oc logs sonarqube-4-build 
oc logs sonarqube-postgresql-1-deploy



