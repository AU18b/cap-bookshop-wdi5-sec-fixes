#!/bin/bash
set -e

echo '############## Get cf Client ##############'
wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo apt-key add -
echo "deb https://packages.cloudfoundry.org/debian stable main" | sudo tee /etc/apt/sources.list.d/cloudfoundry-cli.list
sudo apt-get update
sudo apt-get install cf8-cli

echo '############## Check Installation ##############'
cf -v

echo '############## Install Plugins ##############'
cf add-plugin-repo CF-Community https://plugins.cloudfoundry.org
cf install-plugin multiapps -f
cf install-plugin html5-plugin -f

echo '############## Authorizations ##############'
cf api ${{ env.CF_API }}
cf auth ${{ secrets.CF_USER }} "${{ secrets.CF_PASS }" 

echo '############## Deploy ##############'
cf target -o ${{ env.CF_ORG }} -s ${{ env.CF_SPACE }}
cf deploy ./capire.bookshop_1.0.0.mtar -f
