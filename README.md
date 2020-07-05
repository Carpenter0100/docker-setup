# Docker setup
This is my development docker build for multiple projects.

## What´s in it?

There is default docker-compose file with less container and an extended docker-compose.file.

### Containers
#### docker-compose.xml
1. php 7.4 
2. php 7.4 xdebug
3. mariadb:latest
4. redis:alpine
5. mailhog (localhost:8025)
6. Nginx

#### docker-compose.extended.xml
1. all of the above
2. Elasticsearch v7.8
3. Kibana v7.8 (localhost:5601)
4. RabbitMq v3.8.5 management (localhost:15672)
5. jenkins alpine with ssh plugin for cronjob execution (localhost:8081)
6. redis-commander:latest (localhost:8082)

Features:
1. Use php xdebug container if XDEBUG cookie is active. Otherwise use php container without xdebug installed for performance reasons.
2. If you are a mac user, there is a script to execute to mount the data volume as NFS volume for performance reasons.
3. Add as many projects as you want without a need to change/add nginx configuration.
4. Only official base images are used. If you want to change sth. do it.
5. There are common environment variables by default which will be passed to php containers. Here is a list of them and there default values:
6. Https only with a selfsigned cert in nginx container.
7. Composer and nodejs v14.5 in php containers available. 
8. Every outgoing mail with mail() sent from php containers will be catched and displayed by mailhog under localhost:8025
9. Use Jenkins for cronjob management. Jenkins will connect to php containers and execute a command via ssh.

```
DB_HOST: "localhost"
DB_PORT: "3306"
DB_USER: "${DEFAULT_USER}"
DB_PASSWORD: "${DEFAULT_PASSWORD}"
REDIS_HOST: "redis"
REDIS_PORT: "6379"
REDIS_PASSWORD: "${DEFAULT_PASSWORD}"
ELASTICSEARCH_HOST: "elasticsearch"
ELASTICSEARCH_PORT: "9200"
RABBITMQ_HOST: "rabbitmq"
RABBITMQ_PORT: "5672"
```

Decide yourself which docker-compose file you would like to use or just delete the services you do not need.

#### Environment variables (see .env.dist)

Change them as you like.
The credentials will be used as user/password for every service.

```
COMPOSE_PROJECT_NAME=pws
WORKSPACE_PATH=/my/path/to/workspace
DEFAULT_USER=dev
DEFAULT_PASSWORD=secret
```

It is recommended that you don´t cange the project name.
Volumes will become this prefix. If you change it, some details in this installation guide will be wrong.

## Requirements

1. Docker
2. There is a required naming and directory structure for your projects.
- Usage of TLD ".test" for your local development domain is required.
- your project root directories has the same name as your domain. For example: `"my-project.test"`
- Nginx points automatically to a "public" directory in your project root.

## Phing Setup

1. Add phing.xml as phing file
2. Execute target docker:init:dev

## Manually Setup

#### Folder Structure / Naming

1. Folder Structure / Naming
Pull this repository and put it at the same level as your project root dirs.

```
-- workspace
---- docker-setup
---- your-first-project.test
---- your-second-project.test
---- your-third-project.test
```

2. Environment file
Rename or Copy the file .env.dist to .env

3. Enviroment variables
Replace the string "%%PATH_TO_WORKSPACE%%" in your .env file with the absolute path to your workspace directory.
```
example value: "/my/path/to/workspace"
```

Set the credentials as you like. They will be used for every service. \
For example mariadb/kibana/redis etc...

4. Build
Execute the commands and wait for the build.

```
cd /path/to/workspace/docker-setup
docker-compose up -d 
```

5. Hosts file
Use the Windows/Unix/Mac hosts file to add local development domains for your projects.
This is an example:
```
127.0.0.1 your-fist-project.test
127.0.0.1 your-second-project.test
127.0.0.1 your-third-project.test
```

Remeber that this domain name is also your directory name of your project.

6. Docker for Mac
Docker for mac has a slow file sync. 
After the installation, You can execute following commands to get more performance.
It will mount your data workspace volume as nfs.

```
docker-compose stop
docker-compose volume rm pws_pws-volume-data
./scripts/nfs_for_native_docker.sh
```

7. Add more projects
For example `super-project.test`
- Add this line to your hosts file `127.0.0.1 super-project.test`
- Create a project directory `/path/to/workspace/super-project.test`
- Create a public directory `/path/to/workspace/super-project.test/public`

If you don´t like to have one docker stack for all of your projects, you can create a custom docker build for your project based on this repository.
You don´t have to change much.

Have fun!
