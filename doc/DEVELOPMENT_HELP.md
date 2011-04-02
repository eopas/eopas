## Updating to new ruby version:

    rvm update
    rvm reload
    rvm install 1.9.2

## Updating the app

    git pull
    bundle install

## updating code

    git pull

## migrating the database

    rake db:migrate

## Running a local version of the app

    ./script/rails server

## Running an application console

    ./script/rails cconsole

## Running the tests

    RAILS_ENV=test rake db:schema:load
    rake cucumber
    # or
    rake cucumber:wip


## Running transcoding jobs manually

    rake jobs:work

## Using XSLT

    rails runner bin/xslt.rb [xml file] [xsl file]
    rails runner bin/validate.rb [xml file] [format in Toolbox/Elan/Transcriber/Eopas]
    rails runner bin/transcode.rb [xml file] [format in Toolbox/Elan/Transcriber/Eopas]
