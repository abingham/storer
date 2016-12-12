#!/bin/bash
set -e

my_dir="$( cd "$( dirname "${0}" )" && pwd )"

${my_dir}/gitted_kata/build.sh
${my_dir}/gitted_kata/fill.sh

${my_dir}/build.sh
${my_dir}/up.sh
${my_dir}/test.sh ${*}