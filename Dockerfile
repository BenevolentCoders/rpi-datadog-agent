# Pull base image
FROM hypriot/rpi-alpine-scratch

# Install datadog with dependencies
# 1. basic tools
# 2. python dependencies
# 3. sysstat
# 4. datadog agent from source
RUN apk update \
    && apk upgrade \
    && apk add curl \
    tar \
    musl \
    python \
    python-dev \
    py-virtualenv \
    py-pip \
    sysstat \
    && rm -rf /var/cache/apk/* \
    && DD_START_AGENT=0 sh -c "$(curl -L https://raw.githubusercontent.com/DataDog/dd-agent/master/packaging/datadog-agent/source/setup_agent.sh)"

# Configure the Agent
# 1. Listen to statsd from other containers
# 2. Turn syslog off
# 3. Remove dd-agent user from supervisor configuration
# 4. Remove network check
# 5. Add docker check
RUN mv ~/.datadog-agent/agent/datadog.conf.example ~/.datadog-agent/agent/datadog.conf \
    && sed -i -e"s/^.*non_local_traffic:.*$/non_local_traffic: yes/" ~/.datadog-agent/agent/datadog.conf \
    && sed -i -e"s/^.*log_to_syslog:.*$/log_to_syslog: no/" ~/.datadog-agent/agent/datadog.conf \
    && sed -i "/user=dd-agent/d" ~/.datadog-agent/supervisord/supervisord.conf \
    && rm ~/.datadog-agent/agent/conf.d/network.yaml.default

# Extra conf.d
CMD mkdir -p /conf.d
VOLUME ["/conf.d"]

# Add Docker check
COPY conf.d/docker_daemon.yaml ~/.datadog-agent/agent/conf.d/docker_daemon.yaml
# Add entrypoint
COPY entrypoint.sh /entrypoint.sh

# Expose DogStatsD port
EXPOSE 8125/udp

ENTRYPOINT ["sh","/entrypoint.sh"]
CMD  ~/.datadog-agent/bin/agent start
