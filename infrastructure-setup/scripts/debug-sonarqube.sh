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



