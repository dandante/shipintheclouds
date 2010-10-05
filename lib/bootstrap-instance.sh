#!/bin/bash

set -e -x

#just to make sure we know where we are
cd /root

export AWS_ACCESS_KEY_ID=ACCESS_KEY_PLACEHOLDER
export AWS_SECRET_ACCESS_KEY=SECRET_KEY PLACEHOLDER

echo "Hello from the user script"

apt-get -y update
apt-get -y upgrade

#9:08
# what about when this installs a ruby higher than 1.8?
apt-get -y install ruby

# ... will i need to change the package installed here?
apt-get install -y ruby1.8-dev
#9:08
# ruby 1.8.7

#9:11:17
apt-get -y install rubygems
#9:11:33


#9:21:13
apt-get -y install git-core

apt-get -y install libssl-dev

apt-get -y install libopenssl-ruby

apt-get -y install irb

# already have wget and curl

gem install --no-ri --no-rdoc ruby-mp3info

gem install --no-ri --no-rdoc json

gem install --no-ri --no-rdoc right_aws

gem install --no-ri --no-rdoc uuid

wget http://s3.amazonaws.com/ServEdge_pub/s3sync/s3sync.tar.gz

tar zxf s3sync.tar.gz

# todo - find a way to just download the files we need
# we don't need the whole repo
git clone http://github.com/dandante/shipintheclouds.git

# trap EXIT signal
