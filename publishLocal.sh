#!/usr/bin/env bash

# exit script if any command fails
set -e
set -o pipefail

export GITREV=$(git rev-parse --short HEAD)
export USE_CHISEL7=1
export IVYPATH=~/.ivy2-lpool/local/chipyard-${GITREV}
export SBT_OPTS="-Xmx8G -Xss8M"
unset TARGET_CHIPYARD_LOCATION

echo "Publishing Chipyard libraries locally, to $IVYPATH"

sbt -Dsbt.ivy.home=$IVYPATH "project cde; publishLocal"
sbt -Dsbt.ivy.home=$IVYPATH "project diplomacy; publishLocal"
sbt -Dsbt.ivy.home=$IVYPATH "project hardfloat; publishLocal"
sbt -Dsbt.ivy.home=$IVYPATH "project rocketMacros; publishLocal"
sbt -Dsbt.ivy.home=$IVYPATH "project rocketchip; publishLocal"
sbt -Dsbt.ivy.home=$IVYPATH "project constellation; publishLocal"

ln -sf local/edu.berkeley.cs $IVYPATH

echo "Creating tarball to be uploaded"
tar czf chipyard-${GITREV}.tgz -C ~/.ivy2-lpool/local chipyard-${GITREV}
