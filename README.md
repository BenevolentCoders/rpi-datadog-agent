# rpi-datadog-agent

[![Image Layers](https://badge.imagelayers.io/benevolentcoders/rpi-datadog-agent:latest.svg)](https://imagelayers.io/?images=benevolentcoders/rpi-datadog-agent:latest)
[![Docker Stars](https://img.shields.io/docker/stars/benevolentcoders/rpi-datadog-agent.svg?style=flat-square)][hub]
[![Docker Pulls](https://img.shields.io/docker/pulls/benevolentcoders/rpi-datadog-agent.svg?style=flat-square)][hub]

Raspberry Pi compatible Docker base image the datadog agent preinstalled from source.

Run all the commands from within the project root directory.

## Quick Start

The default image is ready-to-go. You just need to set your hostname and API_KEY in the environment.

```
docker run -d --name dd-agent -h `hostname` -v /var/run/docker.sock:/var/run/docker.sock -v /proc/:/host/proc/:ro -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro -e API_KEY={your_api_key_here} datadog/docker-dd-agent
```

## Configuration

### Environment variables

A few parameters can be changed with environment variables.

* `TAGS` set host tags. Add `-e TAGS="simple-tag-0,tag-key-1:tag-value-1"` to use [simple-tag-0, tag-key-1:tag-value-1] as host tags.
* `LOG_LEVEL` set logging verbosity (CRITICAL, ERROR, WARNING, INFO, DEBUG). Add `-e LOG_LEVEL=DEBUG` to turn logs to debug mode.
* `PROXY_HOST`, `PROXY_PORT`, `PROXY_USER` and `PROXY_PASSWORD` set the proxy configuration.
* `DD_URL` set the Datadog intake server to send Agent data to (used when [using an agent as a proxy](https://github.com/DataDog/dd-agent/wiki/Proxy-Configuration#using-the-agent-as-a-proxy) )

### Enabling integrations

To enable integrations you can write your YAML configuration files in the `/conf.d` folder, they will automatically be copied to `/etc/dd-agent/conf.d/` when the container starts.

1. Create a configuration folder on the host and write your YAML files in it.

    ```
    mkdir /opt/dd-agent-conf.d
    touch /opt/dd-agent-conf.d/nginx.yaml
    ```

2. When creating the container, mount this new folder to `/conf.d`.
    ```
    docker run -d --name dd-agent -h `hostname` -v /var/run/docker.sock:/var/run/docker.sock -v /proc/:/host/proc/:ro -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro -v /opt/dd-agent-conf.d:/conf.d:ro -e API_KEY={your_api_key_here} datadog/docker-dd-agent
    ```

    _The important part here is `-v /opt/dd-agent-conf.d:/conf.d:ro`_

    Now when the container starts, all files in ``/opt/dd-agent-conf.d`` with a `.yaml` extension will be copied to `/etc/dd-agent/conf.d/`. Please note that to add new files you will need to restart the container.

### Build Details
- [Source Project Page](https://github.com/benevolentcoders)
- [Source Repository](https://github.com/benevolentcoders/rpi-datadog-agent)
- [Dockerfile](https://github.com/benevolentcoders/rpi-datadog-agent/blob/master/Dockerfile)
- [DockerHub](https://registry.hub.docker.com/u/benevolentcoders/rpi-datadog-agent/)


#### Build the Docker Image
```bash
make build
```

#### Push the Docker Image to the Docker Hub
* First use a `docker login` with username, password and email address
* Second push the Docker Image to the official Docker Hub

```bash
make push
```

## License

The MIT License (MIT)

Copyright (c) 2015 BenevolentCoders

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

[hub]: https://registry.hub.docker.com/u/benevolentcoders/rpi-datadog-agent/
