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
