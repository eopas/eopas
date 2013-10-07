

# Install

These instructions are geared towards installing the EOPAS application on an
Ubuntu Precise LTS system. These instructions assume you will be using capistrano
to deploy the application.

## Set up the database

Install MySQL if it isn't already installed

``` bash
sudo apt-get install mysql-server
```

Create the EOPAS database and user

```
mysql
mysql> CREATE DATABASE eopas;
mysql> GRANT ALL ON eopas.* to eopas@`%` IDENTIFIED BY 'PASSWORD'
```

Edit config/database.yml to suit database name, username and password.


## Deploy the application to the EOPAS server

We assume you are using Ubuntu Precise.

First set up the **deploy** user

``` bash
sudo adduser deploy
```

You may find deployments easier if you set up your SSH key on the deploy user's
account.

``` bash
ssh-copy-id $USER@server_name.example.org
```

Create the directory the application will be deployed to and set the permissions.

``` bash
sudo mkdir -p /srv/www/eopas
sudo chown deploy.deploy /srv/www/eopas
```

Install all the required dependencies on the server

``` bash
sudo apt-get update
sudo apt-get install ruby1.9.3 git libxml2-dev libxslt1-dev libmysqlclient-dev \
                     libsqlite3-dev build-essentials
sudo gem1.9.3 install bundler
sudo apt-get install libavcodec-extra-53 libavdevice-extra-53 libavfilter-extra-0 \
                     libavformat-extra-53 libpostproc-extra-52 libswscale-extra-2 libav-tools

```

Install capistrano on your local machine

``` bash
gem install capistrano
```

Setup the application for deployment the first time

``` bash
cap deploy:setup
```

Check everything is ready

``` bash
cap deploy:check
```

Deploy the application

``` bash
cap deploy
```

* Run the migrations

``` bash
cap deploy:migrations
```

You will also need to deploy an nginx configuration that looks something like
```
server {
  listen [::]:80;
  server_name www.eopas.org eopas.rnld.unimelb.edu.au;

  access_log  /srv/www/eopas/shared/log/access.log;
  error_log  /srv/www/eopas/shared/log/error.log;

  location / {
    error_page 500 502 503 504 /500.html;

    root /srv/www/eopas/current/public;

    try_files /system/maintenance.html $uri @app;
  }

  location @app {
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_redirect off;

    proxy_pass http://unix:/srv/www/eopas/shared/pids/unicorn.socket;
  }

}

```

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


## Transcoding XML files

You can use the scripts in the bin directory to directly deal with XML files.
Use the following formats: Elan, Toolbox, Transcriber, Eopas

* Transcoding to eopas: e.g.

    rails runner bin/transcode.rb features/test_data/toolbox2.xml Toolbox

* Validating an XML file: e.g.

    rails runner bin/validate.rb features/test_data/toolbox2.xml Toolbox

* Run an xsl tranform: e.g.

    rails runner bin/xslt.rb features/test_data/toolbox2.xml public/XSLT/fixToolbox.xsl

