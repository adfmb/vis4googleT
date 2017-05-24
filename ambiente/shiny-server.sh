#!/bin/sh

# exportando variables de ambiente de llaves de aws
. ./tmp/vamb.sh

# Make sure the directory for individual app logs exists
mkdir -p /var/log/shiny-server
chown shiny.shiny /var/log/shiny-server

exec shiny-server >> /var/log/shiny-server.log 2>&1
