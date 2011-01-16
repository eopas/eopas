




Install
=======

These instructions are catered towards installing the EOPAS application on an
Ubuntu Lucid LTS machine.

Set up the database
-------------------

* Install mysql if it isn't already installed


    aptitude instal mysql-server

* Create the eopas database and user

    mysql
    mysql> CREATE DATABASE eopas;
    mysql> GRANT ALL ON eopas.* to eopas@`%` IDENTIFIED BY 'PASSWORD'

* Edit database.yml to suit database name, username and password.

* Run the migrations

    cap deploy:migrations



Deploy the application
----------------------

* First set up the **deploy** user

    adduser deploy

You may find deployments easier if you set up your SSH key on the deploy user's
account.

* Create the directory the application will be deployed to and set the
  permissions.

    mkdir -p /srv/www/eopas
    chown deploy.deploy /srv/www/eopas

* Install all the required dependencies on the server

**Note:** Currently Ruby1.9.2 isn't in Ubuntu. So we use johnf's PPA.

* The application is deployed from your local machine using capistrano. On your
  local machine make sure capistrano is installed

    apt-add-repository ppa:johnf-inodes/ruby192
    aptitude update
    apt-get install ruby1.9.1 git ruby1.9.1-dev libxml2-dev libxslt1-dev libmysqlclient-dev libsqlite3-dev

    gem1.9.1 install bundler rake


* We recommend using medibuntu for ffmpeg as it supports more codecs. There are
some licensing issues involved. Please make sure you are aware of these before
proceeding.

    wget --output-document=/etc/apt/sources.list.d/medibuntu.list http://www.medibuntu.org/sources.list.d/$(lsb_release -cs).list \
      && apt-get --quiet update \
      && apt-get --yes --quiet --allow-unauthenticated install medibuntu-keyring \
      && apt-get --quiet update
    aptitude update
    apt-get install w64codecs w32codecs libavcodec-extra-52



* Install capistrano on your local machine

    gem install capistrano

* Setup the application for deployment the first time

    cap deploy:setup

* Check everything is ready

    cap deploy:check

* Deploy the application

    cap deploy

* Run the migrations

  cap deploy:migrations

Set up the Web Server
---------------------

This example shows how to set up EOPAS using Nginx with passenger support. There
are many other ways to set up a rails application including using Apache.

**Note:** Currently Nginx with passenger support isn't in Ubuntu. So we use
johnf's PPA.

**Note:** Currently Ruby1.9.2 isn't in Ubuntu. So we use johnf's PPA.

* Install nginx

    apt-add-repository ppa:johnf-inodes/nginx
    apt-add-repository ppa:johnf-inodes/ruby192
    aptitude update
    apt-get install nginx-passenger

* Configure nginx


    vi /etc/nginx/sites-enabled/eopas

    server {
      listen  [::]:80;
      server_name eopas.rnld.unimelb.edu.au;

      rails_env production;

      access_log  /srv/www/eopas/shared/log/access.log;
      error_log  /srv/www/eopas/shared/log/error.log;

      location / {
        root /srv/www/eopas/current/public;
        passenger_enabled on;
        passenger_use_global_queue on;
        client_max_body_size 100m; # Nice and big for videos
      }
    }

    echo -e "passenger_ruby /usr/bin/ruby1.9.1;\n" >> /etc/nginx/conf.d/passenger_ruby1.9.2.conf

* Restart nginx

    service nginx restart

Set up the application
----------------------

Browse to http://DOMAIN and follow the prompts

