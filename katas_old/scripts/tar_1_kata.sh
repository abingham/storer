#!/bin/bash
# script to extract a single kata from a 256th tgz file
# created using get256th.sh

readonly outer=$1  # eg 42
readonly inner=$2  # eg 1AFD7EC5

readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"

tar -zcf ${outer}${inner}.tgz -C . ${outer}/${inner}/
