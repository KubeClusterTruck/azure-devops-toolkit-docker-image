#!/bin/sh
#
# Run simple load test using ACI

export SERVICEIP=$1
export CONTENT_TYPE="Content-Type: application/json"
export PAYLOAD='{"EmailAddress": "email@domain.com", "Product": "prod-1", "Total": 100}'
export ENDPOINT=http://$SERVICEIP/v1/order
export TEST_USERS=20
export TEST_SECONDS=100s

echo "POST $ENDPOINT"
echo $CONTENT_TYPE
echo $PAYLOAD

echo "Phase 1: Warming up - 30 seconds, 100 users."
#  docker run --rm -it azch/loadtest -z 30s -c 100 -d "$PAYLOAD" -H "$CONTENT_TYPE" -m POST "$ENDPOINT"


az container create \
    --resource-group gbc-containers01 \
    --name k8s-challenge-msploadtst01
    --image azch/loadtest:latest \
    --restart-policy Never \
    --command-line $(echo "-z $TEST_SECONDS -c $TEST_USERS -d $PAYLOAD -H $CONTENT_TYPE -m POST $ENDPOINT")