#!/bin/bash

set -e

export $(egrep -v '^#' .env | xargs)

rake db:create
rake db:migrate
