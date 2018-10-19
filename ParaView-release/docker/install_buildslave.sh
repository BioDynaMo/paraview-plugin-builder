#!/bin/sh

set -e

readonly buildslave_version="0.8.10"
readonly buildslave_venv="$HOME/dashboards/venv"

mkdir -p "$buildslave_venv"
cd "$buildslave_venv"
virtualenv .
bin/pip install "buildbot-slave==$buildslave_version"
