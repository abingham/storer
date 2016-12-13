#!/bin/bash
set -e

my_dir="$( cd "$( dirname "${0}" )" && pwd )"

${my_dir}/git_kata/build.sh
${my_dir}/git_kata/fill.sh

${my_dir}/build.sh
${my_dir}/up.sh
${my_dir}/test.sh ${*}