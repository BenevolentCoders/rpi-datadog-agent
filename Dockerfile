# Pull base image
FROM resin/rpi-raspbian:wheezy

# Install dependencies
RUN apt-get update && apt-get install -y \
    python \
    python-dev \
    python-pip \
    python-virtualenv \
    sysstat \
    curl \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/* && \
    DD_START_AGENT=0 sh -c "$(curl --insecure -L https://raw.githubusercontent.com/DataDog/dd-agent/master/packaging/datadog-agent/source/setup_agent.sh)"

    # Configure the Agent
    # 1. Listen to statsd from other containers
    # 2. Turn syslog off
    # 3. Remove dd-agent user from supervisor configuration
    # 4. Remove dd-agent user from init.d configuration
    # 5. Fix permission on /etc/init.d/datadog-agent
    # 6. Remove network check
RUN mv ~/.datadog-agent/agent/datadog.conf.example ~/.datadog-agent/agent/datadog.conf \
    && sed -i -e"s/^.*non_local_traffic:.*$/non_local_traffic: yes/" ~/.datadog-agent/agent/datadog.conf \
    && sed -i -e"s/^.*log_to_syslog:.*$/log_to_syslog: no/" ~/.datadog-agent/agent/datadog.conf \
    && sed -i "/user=dd-agent/d" ~/.datadog-agent/supervisord/supervisord.conf \
    && rm ~/.datadog-agent/agent/conf.d/network.yaml.default \
    && cp ~/.datadog-agent/agent/conf.d/docker_daemon.yaml.example ~/.datadog-agent/agent/conf.d/docker_daemon.yaml

# Add Docker check
# COPY conf.d/docker_daemon.yaml /etc/dd-agent/conf.d/docker_daemon.yaml

CMD sh -c "sed 's/api_key:.*/api_key: "$API_KEY"/' ~/.datadog-agent/agent/datadog.conf.example > ~/.datadog-agent/agent/datadog.conf" &&  ~/.datadog-agent/bin/agent start
