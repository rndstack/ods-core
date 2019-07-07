#!/usr/bin/env bash

. ../../local.config

#current workdir
cwd=${PWD}
if [ ! -d "$OPENDEVSTACK_BASE_DIR/certs" ] ; then
  mkdir $OPENDEVSTACK_BASE_DIR/certs
fi

vagrant ssh openshift -c "sudo bash -x /ods/ods-core/infrastructure-setup/scripts/debug-sonarqube.sh"