#!/bin/bash
# Author : hemanth.hm@gmail.com
# Site : www.h3manth.com
# This script helps to setup diaspora.
#

# Set extented globbing 
shopt -s extglob

# Check if the user has root privilages 
[ "$(whoami)" != "root" ] && echo "Please run this script as root/sudo" && exit 1

# Install build tools 
echo "Installing build tools.."
sudo aptitude install build-essential libxslt1.1 libxslt1-dev libxml2
echo "..Done installing build tools"

# Install Ruby 1.8.7 
echo "Installing ruby-full Ruby 1.8.7.." 
sudo aptitude install ruby-full
echo "..Done installing Ruby"

# Install Rake 
echo "Installing rake.."
sudo aptitude install rake
echo "..Done installing rake"

# Get the current release and install mongodb
lsb=$(lsb_release -rs)
ver=${lsb//.+(0)/.}
repo="deb http://downloads.mongodb.org/distros/ubuntu ${ver} 10gen"
echo "Setting up MongoDB.."
echo "."
echo ${repo} | sudo tee -a /etc/apt/sources.list
echo "."
echo "Fetching keys.."
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
echo "."
sudo aptitude update
echo "."
sudo aptitude install mongodb-stable
echo "Done installing monngodb-stable.."

# Install imagemagick
echo "Installing imagemagick.."
sudo aptitude install imagemagick libmagick9-dev
echo "Installed imagemagick.."

# Install git-core
echo "Installing git-core.."
sudo aptitude install git-core
echo "Installed git-core.."

# Setting up ruby gems
echo "Fetching and installing ruby gems.."
(
    echo "."
    cd /tmp 
    wget http://production.cf.rubygems.org/rubygems/rubygems-1.3.7.tgz
    echo "."
    tar -xf rubygems-1.3.7.tgz
    echo "."
    cd rubygems-1.3.7
    echo "."
    sudo ruby setup.rb
    echo "."
    sudo ln -s /usr/bin/gem1.8 /usr/bin/gem 
    echo "."    
) 
echo "Done installing the gems.."

# Install blunder
echo "Installing blunder.."
sudo gem install bundler
echo "Installed blunder.."

# Take a clone of Diaspora
(
echo "Clone diaspora source.."
git clone http://github.com/diaspora/diaspora.git
echo "Cloned the source.."
# Install extra gems 
cd diaspora
echo "Installing more gems.."
bundle install
echo "Installed."

# Install DB setup 
echo "Seting up DB.."
rake db:seed:tom
echo "DB ready. Login -> tom and password -> evankorth. More details ./diaspora/db/seeds/tom.rb."

# Run appserver 
echo "Starting server"
bundle exec thin start 
)
