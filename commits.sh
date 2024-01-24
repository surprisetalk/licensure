#!/bin/bash

GITHUB_TOKEN="$1"

while read REPO; do

  sleep 10

  LICENSE=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
                    -H "Accept: application/vnd.github.v3+json" \
                       "https://api.github.com/repos/$REPO/license" | jq -r '.path')

  if [ ! -z "$LICENSE" -a "$LICENSE" != "null" ]; then

    COMMIT_DATA=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
                          -H "Accept: application/vnd.github.v3+json" \
                             "https://api.github.com/repos/$REPO/commits?path=$LICENSE")
    
    echo "$COMMIT_DATA" | jq -c '.[]' | while IFS= read -r line; do

        COMMITED_AT=$(echo "$line" | jq -r '.commit.author.date')
        COMMIT_SHA=$(echo "$line" | jq -r '.sha')
    
        ROW="$COMMITED_AT,$REPO,$COMMIT_SHA"
        
        # Check if the row exists in commits.csv, and if not, append it
        grep -qxF "$ROW" commits.csv || echo "$ROW" >> commits.csv

    done

  fi

done < repos.txt
