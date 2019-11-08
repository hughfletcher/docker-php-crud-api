#!/bin/sh

for item in `env`; do
   case "$item" in
       PCA_*)
            ENVVAR=`echo $item | cut -d \= -f 1`
            if [ $ENVVAR = "PCA_HTPASSWD" ]
            then
              HTPASS=`printenv $ENVVAR`
              echo $HTPASS >> /var/www/html/.htpasswd
              tr , '\n' < /var/www/html/.htpasswd
              chown www-data /var/www/html/.htpasswd
              continue
            fi
            if [ $ENVVAR = "PCA_CONFIG_EXTRA" ]
            then
              EXTRA_CONFIG=`printenv $ENVVAR`
              sed -i "/'database' => 'php-crud-api'/a$EXTRA_CONFIG" /var/www/html/index.php
              continue
            fi
            if [ $ENVVAR = "PCA_ADDRESS" ]
            then
              DB_ADDRESS=`printenv $ENVVAR`
              sed -i "/'database' => 'php-crud-api'/a ,'address' => '$DB_ADDRESS'" /var/www/html/index.php
              continue
            fi
            if [ $ENVVAR = "PCA_USER" ]
            then
              DB_USER=`printenv $ENVVAR`
              continue
            fi
            if [ $ENVVAR = "PCA_PASSWORD" ]
            then
              DB_PASSWORD=`printenv $ENVVAR`
              continue
            fi
            if [ $ENVVAR = "PCA_DATABASE" ]
            then
              DB_DATABASE=`printenv $ENVVAR`
            fi
   esac
done

/bin/sed -ri -e "s!'username' => 'php-crud-api'!'username' => '$DB_USER'!g" /var/www/html/index.php
/bin/sed -ri -e "s!'password' => 'php-crud-api'!'password' => '$DB_PASSWORD'!g" /var/www/html/index.php
/bin/sed -ri -e "s!'database' => 'php-crud-api'!'database' => '$DB_DATABASE'!g" /var/www/html/index.php

docker-php-entrypoint apache2-foreground
