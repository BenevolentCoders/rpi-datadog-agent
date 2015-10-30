# Pull base image
FROM resin/rpi-raspbian:wheezy

# Install dependencies
RUN apt-get update && apt-get install -y \
    python \
    python-dev \
    python-pip \
    python-virtualenv \
    sysstat && \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/* && \
    sh -c "$(curl -L https://raw.githubusercontent.com/DataDog/dd-agent/master/packaging/datadog-agent/source/setup_agent.sh)"

CMD sh -c "sed 's/api_key:.*/api_key: 19f7d22b762000d031104d035bfca14a/' ~/.datadog-agent/agent/datadog.conf.example > /etc/dd-agent/datadog.conf" &&  ~/.datadog-agent/bin/agent start
