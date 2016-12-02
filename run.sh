#!/bin/bash

# set variables
GIT_COMMIT_SHORT=${WERCKER_GIT_COMMIT:0:7}
GITHUB_URL="https://${WERCKER_GIT_DOMAIN}/${WERCKER_GIT_OWNER}/${WERCKER_GIT_REPOSITORY}/tree/${WERCKER_GIT_COMMIT}"

# check if slack webhook url is present
if [ -z "$WERCKER_SLACK_WEBHOOK" ]; then
  error 'Please provide a Slack webhook URL'
  exit 1
fi

# set variables depending on buidl result
if [ "$WERCKER_RESULT" = 'passed' ]; then
    TEXT="Build successfull"
    COLOR="#36A64F"
else
    TEXT="Build failed"
    COLOR="#DA3148"
fi

# make request
curl -X POST -H 'Content-type: application/json' \
--data '{
    "username": "Wercker",
    "icon_url": "https://cdn.rawgit.com/alexblunck/wercker-slack/728a78f50ac274a8001013c7b246e87ddaf8e769/wercker-icon.png",
    "attachments": [
        {
            "text": "'"$TEXT"'",
            "color": "'$COLOR'",
            "fields": [
                {
                    "title": "Project",
                    "value": "'"$WERCKER_APPLICATION_NAME"'",
                    "short": true
                },
                {
                    "title": "Commit",
                    "value": "<'$GITHUB_URL'|'$GIT_COMMIT_SHORT'>",
                    "short": true
                },
                {
                    "title": "Build",
                    "value": "<'$WERCKER_BUILD_URL'|'$WERCKER_BUILD_ID'>",
                    "short": false
                }
            ]
        }
    ]
}' \
$WERCKER_SLACK_WEBHOOK
