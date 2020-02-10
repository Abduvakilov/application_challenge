#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -ex

rake db:create
rake db:migrate

exec "/bin/bash"
