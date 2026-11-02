#!/bin/sh

set -e

find /app/curl.d  -name '*.sh' | while read file; do
    source $file
done;
