#!/bin/bash

GITHUB_TOKEN="$1"

PAGE=1

while : ; do
    RESPONSE=$(curl -H "Authorization: token $GITHUB_TOKEN" \
                    -H "Accept: application/vnd.github.v3+json" \
                      "https://api.github.com/search/repositories?q=stars:>100&sort=stars&order=desc&per_page=100&page=$PAGE")
    
    COUNT=$(echo "$RESPONSE" | jq '.items | length')
    if [[ "$COUNT" -eq 0 ]]; then
        break
    fi
    
    echo "$RESPONSE" | jq -r '.items[] | "\(.full_name)"' >> repos.txt
    echo "$RESPONSE" | jq -r '.items[] | "\(.full_name),\(.license.spdx_id)"' >> licenses.csv

    ((PAGE++))
done
