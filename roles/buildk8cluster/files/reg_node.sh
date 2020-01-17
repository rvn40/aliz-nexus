#!/bin/bash

curl -s 'https://k8mgmtnexus.fourtyspace.com/v3/clusterregistrationtoken' -H 'content-type: application/json' -H "Authorization: Bearer token-nd6lx:p42zh4gfhxwxjdwx4zsg6rrrnjhvhx95pwdkxgmht552thrft47q9x" --data-binary '{"type":"clusterRegistrationToken","clusterId":"'c-94zcx'"}' --insecure > /dev/null
ROLEFLAGS="--etcd --controlplane --worker"
AGENTCMD=`curl -s 'https://k8mgmtnexus.fourtyspace.com/v3/clusterregistrationtoken?id="'c-94zcx'"' -H 'content-type: application/json' -H "Authorization: Bearer token-nd6lx:p42zh4gfhxwxjdwx4zsg6rrrnjhvhx95pwdkxgmht552thrft47q9x" --insecure | jq -r '.data[].nodeCommand' | head -1`
DOCKERRUNCMD="$AGENTCMD $ROLEFLAGS"
echo $DOCKERRUNCMD