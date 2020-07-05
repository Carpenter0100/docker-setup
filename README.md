# Docker setup
This is my development docker build for multiple projects.

## What´s in it?

### Containers
#### docker-compose.xml
1. php 7.4 
2. php 7.4 xdebug (this container extends from the first one)
3. mariadb:latest
4. redis:alpine
5. mailhog (localhost:8025)
6. nginx:alpine

#### docker-compose.extended.xml
1. All of the above
2. Elasticsearch v7.8
3. Kibana v7.8 (localhost:5601)
4. RabbitMq v3.8.5 management (localhost:15672)
5. Jenkins alpine (localhost:8081)
6. redis-commander:latest (localhost:8082)

Features:
1. Nginx will only use the php xdebug container if `XDEBUG_SESSION` cookie is active. Otherwise, the normal php container without xdebug installed will be used. This increased my development speed. Use an empty value for the cookie.
2. If you are a mac user, there is a script to execute to mount the data volume as NFS volume for performance reasons.
3. Use this docker setup for multiple projects at once.
4. I used only official base images. If you want to change sth. Do it.
5. Https only with a selfsigned certificate in nginx container.
6. Composer and nodejs v14.5 in php containers available. 
7. Every outgoing mail with mail() sent from php containers will be displayed by mailhog under localhost:8025. Mails will not leave your local development environment anymore ;-)
8. Use Jenkins for cronjob management. Jenkins will connect to the php container via ssh plugin and can executes commands.
9. There are common environment variables by default which will be passed to php containers. Here is a list of them and there default values:

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

It is recommended that you don´t change the project name.
Volumes will become this prefix. If you change it, some details in this guide will be wrong.

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
Copy the file `.env.dist` to `.env` at the same level.

3. Enviroment variables
Replace the string "%%PATH_TO_WORKSPACE%%" in your `.env` file with the absolute path to your workspace directory.
```
example value: "/my/path/to/workspace"
```

Set the credentials as you like. They will be used for every service. \
For example `mariadb` `kibana` `redis` etc...

4. Hosts file
Use the Windows/Unix/Mac hosts file to add local development domains for your projects.
This is an example:
```
127.0.0.1 your-fist-project.test
127.0.0.1 your-second-project.test
127.0.0.1 your-third-project.test
```

Remember that this domain name is also your directory name of your project.

5. Build
Execute the commands and wait for the build.

```
cd /path/to/workspace/docker-setup
docker-compose up -d 
```

6. Docker for Mac
Docker for mac users has a slow file sync by default. 
After the installation! You can execute following commands to get more performance.
It will mount your data workspace volume as nfs.

```
docker-compose stop
docker-compose volume rm pws_pws-volume-data
./scripts/nfs_for_native_docker.sh
```

7. From time to time you will get more projects. What your need to do.
For example `super-project.test`
- Add this line to your hosts file `127.0.0.1 super-project.test`
- Create a project directory `/path/to/workspace/super-project.test`
- Create a public directory `/path/to/workspace/super-project.test/public`
- Create your index.php file `/path/to/workspace/super-project.test/public/index.php`

If you don´t like to have one docker stack for all of your projects, you can create a custom docker build for each based on this repository.
You don´t have to change much.

Have fun!
