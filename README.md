> [!NOTE]
> This Docker image is based on a [LinuxServer.io](https://www.linuxserver.io/) image and inherits all of its features and capabilities. Some sections of this README have been inspired by or adapted from documentation provided by LinuxServer.io to streamline information and avoid unnecessary repetition. Thanks to the LinuxServer.io team for their work.

# Docker image for [Zheoni/cooklang-chef](https://github.com/Zheoni/cooklang-chef)

[Zheoni/cooklang-chef](https://github.com/Zheoni/cooklang-chef) is a CLI to manage [cooklang](https://cooklang.org/) recipes with extensions.

## Application Setup

Access the webui at `<your-ip>:8080`, for more information check out [Chef documentation](https://github.com/Zheoni/cooklang-chef/blob/main/docs/README.md).

## Non-Root Operation

This image can be run with a non-root user. For details please [read the LinuxServer.io docs](https://docs.linuxserver.io/misc/non-root/).

## Usage

To help you get started creating a container from this image you can either use docker-compose or the docker cli.

> [!NOTE]
> Unless a parameter is flaged as 'optional', it is *mandatory* and a value must be provided.

### docker-compose (recommended, [click here for more info - LinuxServer.io](https://docs.linuxserver.io/general/docker-compose))

```yaml
---
services:
  chef:
    image: ghcr.io/tr4cks/docker-cooklang-chef:latest
    container_name: chef
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
    volumes:
      - /path/to/chef/recipes:/recipes
    ports:
      - 8080:8080
    restart: unless-stopped
```

### docker cli ([click here for more info](https://docs.docker.com/engine/reference/commandline/cli/))

```bash
docker run -d \
  --name=chef \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 8080:8080 \
  -v /path/to/chef/recipes:/recipes \
  --restart unless-stopped \
  ghcr.io/tr4cks/docker-cooklang-chef:latest
```

## Parameters

Containers are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 8080:8080` | Port for Chef's web interface. |
| `-e PUID=1000` | for UserID - see below for explanation |
| `-e PGID=1000` | for GroupID - see below for explanation |
| `-e TZ=Etc/UTC` | specify a timezone to use, see this [list](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List). |
| `-v /recipes` | Destination of chef recipes |
| `--read-only=true` | Run container with a read-only filesystem. Please [read the docs from LinuxServer.io](https://docs.linuxserver.io/misc/read-only/). |
| `--user=1000:1000` | Run container with a non-root user. Please [read the docs from LinuxServer.io](https://docs.linuxserver.io/misc/non-root/). |

## User / Group Identifiers

When using volumes (`-v` flags), permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id your_user` as below:

```bash
id your_user
```

Example output:

```text
uid=1000(your_user) gid=1000(your_user) groups=1000(your_user)
```
