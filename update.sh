#!/bin/bash

cd "$(dirname "$0")"
source 'ci-library.sh'

execute 'Updating system' update_system

