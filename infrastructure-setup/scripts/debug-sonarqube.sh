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
oc get pods --all-namespaces

oc delete pod sonarqube-2-build

mkdir /etc/systemd/system/docker.service.d

cat > /etc/systemd/system/docker.service.d/http-proxy.conf <<-EOF
[Service]
Environment="HTTP_PROXY=http://192.168.196.221:1087/"
Environment="HTTPS_PROXY=http://192.168.196.221:1087/"
Environment="NO_PROXY=localhost,127.0.0.0/8,docker-registry.somecorporation.com"
EOF
systemctl daemon-reload
systemctl restart docker



# 由于迁移过来的git 配置还有些问题, 导致无法clone 源代码

NAME                                               TYPE      FROM             STATUS                       STARTED             DURATION
build.build.openshift.io/sonarqube-1               Docker    Git@production   Failed (FetchSourceFailed)   About an hour ago   2m2s
build.build.openshift.io/sonarqube-2               Docker    Git@production   Failed (FetchSourceFailed)   About an hour ago   2s
build.build.openshift.io/sonarqube-3               Docker    Git@production   Failed (FetchSourceFailed)   About an hour ago   2s
build.build.openshift.io/jenkins-master-1          Docker    Git@production   Failed (FetchSourceFailed)   39 minutes ago      2s
build.build.openshift.io/jenkins-master-2          Docker    Git@production   Failed (FetchSourceFailed)   39 minutes ago      2s
build.build.openshift.io/jenkins-slave-base-1      Docker    Git@production   Failed (FetchSourceFailed)   39 minutes ago      1s
build.build.openshift.io/jenkins-webhook-proxy-1   Docker    Git@production   Failed (FetchSourceFailed)   39 minutes ago      2s


# 先配置好sso服务



oc logs sonarqube-2-build -n cd

# oc describe build docker-build
# docker logs docker-build
echo "oc describe pod jenkins-master-1-build"
oc describe pod sonarqube-2-build

echo "oc logs jenkins-master-1-build -c git-clone"
oc logs jenkins-master-1-build -c git-clone
oc logs sonarqube-2-build -c git-clone

oc describe pod sonarqube-postgresql-1-deploy
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



