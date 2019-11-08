# What is php-crud-api?

[Php-crud-api](https://github.com/mevdschee/php-crud-api) is a single file PHP script that adds a REST API to a SQL database. The scripts/app are Copyright (c) 2019 Maurits van der Schee(https://github.com/mevdschee) and is released under the MIT License.

# How to use this image

This image provides Apache services only. A separate Sql instance is required. MySQL 5.6 InnoDB, PostgreSQL 9.1 and MS SQL Server 2012 are fully supported.

## Start a MySQL server instance

```console
$ docker run --name database -e MYSQL_USER=user -e MYSQL_PASSWORD=password -e MYSQL_DATABASE=db -e MYSQL_RANDOM_ROOT_PASSWORD=1 -d mysql:5.7
```

...read more about this image at [Docker Hub - MySql](https://hub.docker.com/_/mysql).

## Start a php-crud-api server instance

```console
$ docker run --name api -p 80:80 -e MYSQL_HOST=db -e MYSQL_USER=user -e MYSQL_PASSWORD=password -e MYSQL_DATABASE=db --link="database" -d hughfletcher/php-crud-api:tag
```

... where `tag` is the tag specifying the docker-php-crud-api version you want. Read more about the environment variables and other options below.

## ... via [`docker stack deploy`](https://docs.docker.com/engine/reference/commandline/stack_deploy/) or [`docker-compose`](https://github.com/docker/compose)

Example `docker-compose.yml` for `php-crud-api`:

```yaml
version: '3.2'

services:
  api:
    image: hughfletcher/docker-php-crud-api:latest
    restart: always
    ports:
      - 80:80
    environment:
      PCA_PASSWORD: world
      PCA_USER: world
      PCA_DATABASE: world
      PCA_ADDRESS: db
      PCA_CONFIG_EXTRA: ",'middlewares' => 'cors,basicAuth'"
      PCA_HTPASSWD: 'username1:password1'
  db:
    image: mysql:5.7
    volumes:
      - ./testing:/docker-entrypoint-initdb.d
    environment:
      MYSQL_ROOT_PASSWORD: world
      MYSQL_USER: world
      MYSQL_PASSWORD: world
      MYSQL_DATABASE: world
  adminer:
    image: adminer:latest
    networks:
      - default
    ports:
      - 8080:8080
    restart: always
```

## Environment Variables

When you start the `docker-php-crud-api` image, you are required to configure which SQL instance it connects to by passing four environment variables on the `docker run` command line.

### `PCA_ADDRESS`, `PCA_DATABASE`, `PCA_USER`, `PCA_PASSWORD`

The above variables are mandatory and specifies the connection properties of your target db.

### `PCA_CONFIG_EXTRA`

This is an optional variable. Using this variable allows you to set additional php array key/values to be added inside the config array of the php-crud-api script.

```yaml
PCA_CONFIG_EXTRA: ",'driver => 'sqlsrv', 'middlewares' => 'cors,basicAuth'"
```

or

```yaml
- PCA_CONFIG_EXTRA=
  ,'driver => 'sqlsrv'
  , 'middlewares' => 'cors,basicAuth'
```

### `PCA_HTPASSWD`

This is an optional variable. This variable will create a .htpasswd file at image instantiation to use with the basic authentication provided by the php-crud-api script. To set these provide a username and a unencrypted password separated by a colon. For multiple entries sperate these pairs with a comma.

```yaml
PCA_HTPASSWD: 'username1:password1,username2:password2,username3:password3'
```

Please note this variable only creates the .htpasswd file. 'basicAuth', along with any other php-crud-api config options, should still be added to the 'middlewares' config via the `PCA_CONFIG_EXTRA` variable above.
<!--
php -r "echo substr(base64_encode('username1:password1'),0,-2);")
-->
