#!/bin/bash
#set -e

if [[ $API_KEY ]]; then
	sed -i -e "s/^.*api_key:.*$/api_key: ${API_KEY}/" ~/.datadog-agent/agent/datadog.conf
else
	echo "You must set API_KEY environment variable to run the Datadog Agent container"
	exit 1
fi

if [[ $TAGS ]]; then
	sed -i -e "s/^#tags:.*$/tags: ${TAGS}/" ~/.datadog-agent/agent/datadog.conf
fi

if [[ $LOG_LEVEL ]]; then
    sed -i -e"s/^.*log_level:.*$/log_level: ${LOG_LEVEL}/" ~/.datadog-agent/agent/datadog.conf
fi

if [[ $DD_URL ]]; then
  sed -i -e "s/^.*dd_url:.*$/dd_url: ${DD_URL}/" ~/.datadog-agent/agent/datadog.conf
fi

if [[ $PROXY_HOST ]]; then
    sed -i -e "s/^# proxy_host:.*$/proxy_host: ${PROXY_HOST}/" ~/.datadog-agent/agent/datadog.conf
fi

if [[ $PROXY_PORT ]]; then
    sed -i -e "s/^# proxy_port:.*$/proxy_port: ${PROXY_PORT}/" ~/.datadog-agent/agent/datadog.conf
fi

if [[ $PROXY_USER ]]; then
    sed -i -e "s/^# proxy_user:.*$/proxy_user: ${PROXY_USER}/" ~/.datadog-agent/agent/datadog.conf
fi

if [[ $PROXY_PASSWORD ]]; then
    sed -i -e "s/^# proxy_password:.*$/proxy_password: ${PROXY_USER}/" ~/.datadog-agent/agent/datadog.conf
fi

find /conf.d -name '*.yaml' -exec cp {} ~/.datadog-agent/agent/conf.d \;

exec "$@"
