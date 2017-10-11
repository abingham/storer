#!/bin/bash

# Note that the --host is needed for IPv4 and IPv6 addresses
bundle exec rackup --host 0.0.0.0 -p ${PORT}
