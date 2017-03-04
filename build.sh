#!/bin/bash

my_dir="$( cd "$( dirname "${0}" )" && pwd )"

${my_dir}/server/git_kata/build.sh
${my_dir}/server/git_kata/fill.sh

docker-compose --file ${my_dir}/docker-compose.yml build
