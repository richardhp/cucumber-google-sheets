# Cucumber Google Sheets

This project will produce a docker image that can be run to process Cucumber messages in the [ndjson format](http://ndjson.org/).

It will then post them to a google spreadsheet

It will also allow exporting to csv for local viewing

## Google Auth

In order to authenticate with google, you must create a service account that has access to your spreadsheet.

You can then download the service account keys as a json file and then mount it into the docker container using docker-compose
