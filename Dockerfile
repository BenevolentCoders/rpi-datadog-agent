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
    sh -k -c "$(curl -L https://raw.githubusercontent.com/DataDog/dd-agent/master/packaging/datadog-agent/source/setup_agent.sh)"

CMD sh -c "sed 's/api_key:.*/api_key: "$API_KEY"/' ~/.datadog-agent/agent/datadog.conf.example > ~/.datadog-agent/agent/datadog.conf" &&  ~/.datadog-agent/bin/agent start
