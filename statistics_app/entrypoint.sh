#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -ex

# Get environment variables from .env file
export $(egrep -v '^#' .env | xargs)

rake db:create
