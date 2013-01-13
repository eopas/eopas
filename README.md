

# Install

These instructions are geared towards installing the EOPAS application on an
Ubuntu Lucid LTS system. These instructions assume you will be using capistrano
to deploy the application.

## Set up the database

* Install MySQL if it isn't already installed

    aptitude install mysql-server

* Create the EOPAS database and user

    mysql
    mysql> CREATE DATABASE eopas;
    mysql> GRANT ALL ON eopas.* to eopas@`%` IDENTIFIED BY 'PASSWORD'

* Edit config/database.yml to suit database name, username and password.

* Run the migrations

    cap deploy:migrations


## Deploy the application to the EOPAS server


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
proceeding. ffmpeg is used for transcoding media files.

    wget --output-document=/etc/apt/sources.list.d/medibuntu.list http://www.medibuntu.org/sources.list.d/$(lsb_release -cs).list \
      && apt-get --quiet update \
      && apt-get --yes --quiet --allow-unauthenticated install medibuntu-keyring \
      && apt-get --quiet update
    aptitude update
    apt-get install w64codecs w32codecs libavcodec-extra-52 libavdevice-extra-52 \
      libavfilter-extra-0 libavformat-extra-52 libpostproc-extra-51 \
      libswscale-extra-0 ffmpeg



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




## Set up the application


Browse to http://DOMAIN and follow the prompts


## Information about automatic transcoding


When you deploy with capistrano, the delayed\_jobs gem will be set up for you
and take care of the transcoding tasks necessary after uploading audio and video files.
Normally, everything should be fine. But occasionally you may need to deal with stuck
jobs or other issues.

* Running the delayed\_jobs demon by hand if necessary

    RAILS_ENV=production ./scripts/delayed_job start

* Clearing the jobs queue

    rake jobs:clear

* Checking the jobs queue as an admin user

    http://DOMAIN/delayed_job_admin


## Updating the language codes


The language codes in use for EOPAS are sourced from http://www.ethnologue.com/codes/.

To update them:

* Download the latest version of the three tables from

    http://www.ethnologue.com/codes/default.asp#downloading

* Copy them into the data directory, overwriting the existing files there

Done!
