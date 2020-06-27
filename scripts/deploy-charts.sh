#!/bin/bash

CHARTS="plex transmission"
AUTO_YES=0

case $1 in
  -h)
    cat <<EOF
Build latest packages in .deploy-CHART, tag
and deploy and index every chart in these directories

-h      this help
-y      yes to all
EOF
    exit 0
    ;;
  -y)
    AUTO_YES=1
    ;;
  *)
    ;;
esac

for c in ${CHARTS}
do
  CVERSION=$(yq read ${c}/Chart.yaml version)
  rm -rf .deploy && mkdir -p .deploy
  [ $AUTO_YES -ne 1 ] && echo "Deploy (${c}-${CVERSION}) ? [y/N]" && read DEPLOY
  if [ "${DEPLOY}" == "y" ] || [ $AUTO_YES -eq 1 ]
  then
    helm package ${c} -d .deploy/
    git tag ${c}-${CVERSION}
    if [ $? -ne 0 ]
    then
      echo "Tag ${c}-${CVERSION} exists"
    else
      git push origin ${c}-${CVERSION}
    fi
    UUID=$(uuidgen)
    upload=$(cr upload --package-path .deploy 2>&1)
    if [ $? -ne 0 ]
    then
      echo $upload | grep -q "already_exists"
      [ $? -ne 0 ] && echo "Error: $(echo $upload)" && exit 1
    fi
    mkdir -p .index-${UUID}
    cr index --package-path .deploy/ -i .index-${UUID}/index.yaml
    yq m -i index.yaml .index-${UUID}/index.yaml
    echo "Chart ${c}-${CVERSION} uploaded and indexed"
    rm -rf .index-${UUID}
  fi
done
