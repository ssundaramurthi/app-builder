#!/bin/bash

set -euo pipefail

export REPOSITORY=git@github.com:ssundaramurthi/app-builder.git

CURRENT_DIR=$(pwd)
ROOT_DIR="$( dirname "${BASH_SOURCE[0]}" )"/..
STATUS_CHECK=false

USAGE="USAGE: $(basename "$0")

Eg: build-pipeline

NOTE: BUILDKITE_API_TOKEN, BUILDKITE_ORG_SLUG must be set in environment

ARGUMENTS:
    -r | --repository     github repository url (optional, default: app-builder)
    -h | --help           show this help text"

[ -z $BUILDKITE_API_TOKEN ] && { echo "BUILDKITE_API_TOKEN is not set in environment."; exit 1;}
[ -z $BUILDKITE_ORG_SLUG ] && { echo "BUILDKITE_ORG_SLUG is not set in environment."; exit 1;}

while [ $# -gt 0 ]; do
    if [[ $1 =~ "--"* ]]; then
        case $1 in
            --help|-h) echo "$USAGE"; exit; ;;
            --repository|-r) REPOSITORY=$2;;
        esac
    fi
    shift
done

export PIPELINE_NAME=app-builder-pipeline

PIPELINE_CONFIG_FILE=./pipelines/app-builder-pipeline.json
[ ! -f "$PIPELINE_CONFIG_FILE" ] && { echo "Invalid pipeline type: File not found $PIPELINE_CONFIG_FILE"; exit; }

PIPELINE_CONFIG=$(cat $PIPELINE_CONFIG_FILE | envsubst)

if [ $STATUS_CHECK == "false" ]; then
  pipeline_settings='{ "provider_settings": { "trigger_mode": "none" } }'
  PIPELINE_CONFIG=$((echo $PIPELINE_CONFIG; echo $pipeline_settings) | jq -s add)
fi

cd $ROOT_DIR

echo "Creating $PIPELINE_NAME.."
RESPONSE=$(curl -s POST "https://api.buildkite.com/v2/organizations/$BUILDKITE_ORG_SLUG/pipelines" \
  -H "Authorization: Bearer $BUILDKITE_API_TOKEN" \
  -d "$PIPELINE_CONFIG"
)

[[ "$RESPONSE" == *errors* ]] && { echo $RESPONSE | jq; exit 1; }

echo $RESPONSE | jq
WEB_URL=$(echo $RESPONSE | jq -r '.web_url')
WEBHOOK_URL=$(echo $RESPONSE | jq -r '.provider.webhook_url')

echo "Pipeline url: $WEB_URL"
echo "Webhook url: $WEBHOOK_URL"
echo "$PIPELINE_NAME pipeline created."

cd $CURRENT_DIR

unset REPOSITORY
unset PIPELINE_NAME
