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
  CHART_TAGGED_VERSIONS=""
  mkdir -p .deploy-${c}
  CHART_TAGGED_VERSIONS=$(ls .deploy-${c}/${c}* | grep -oE "${c}-[0-9].[0-9].[0-9]")
  [ $AUTO_YES -ne 1 ] && echo "Deploy (${CHART_TAGGED_VERSIONS}) ? [y/N]" && read DEPLOY
  if [ "${DEPLOY}" == "y" ] || [ $AUTO_YES -eq 1 ]
  then
    UUID=$(uuidgen)
    upload=$(cr upload --package-path .deploy-${c}/ 2>&1)
    if [ $? -eq 1 ]
    then
      echo $upload | grep -q "already_exists"
      [ $? -eq 1 ] && echo "Error: $(echo $upload)" && exit 1
    fi
    mkdir -p .index-${UUID}
    cr index --package-path .deploy-${c}/ -i .index-${UUID}/index.yaml
    yq m -i index.yaml .index-${UUID}/index.yaml
    echo "Chart ${c} (${CHART_TAGGED_VERSIONS}) uploaded and indexed"
    rm -rf .index-${UUID}
  fi
done
