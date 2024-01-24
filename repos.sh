#!/bin/bash

GITHUB_TOKEN="$1"

PAGE=1

while : ; do
    RESPONSE=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
                       -H "Accept: application/vnd.github.v3+json" \
                          "https://api.github.com/search/repositories?q=stars:>1000&sort=updated&order=desc&per_page=100&page=$PAGE")
    
    COUNT=$(echo "$RESPONSE" | jq '.items | length')
    if [[ "$COUNT" -eq 0 ]]; then
      PAGE=1
    fi

    echo "$RESPONSE" | jq -r '.items[] | .full_name' | while read REPO; do
      if ! grep -qxF "$REPO" repos.txt; then
        echo "$REPO" >> repos.txt
      fi
    done

    echo "$RESPONSE" | jq -r '.items[] | "\(.full_name),\(.license.spdx_id)"' | while read LICENSE; do
      if ! grep -qxF "$LICENSE" licenses.csv; then
        echo "$LICENSE" >> licenses.csv
      fi
    done

    ((PAGE++))
done
