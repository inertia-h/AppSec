#!/bin/bash

# translates hostnames or domain names to static IP addresses #
ETC_HOSTS=/etc/hosts

hack_app() { 
app = $1
project = $2
dockername = $3
ip = $4
port = $5
port2 = $6

echo "Starting $app"
addhost "$ip" "$project"

if [ "$(sudo docker ps -aq -f name=$project)" ]; 
  then
    echo "Running command: docker start $project"
    sudo docker start $project
  else
    if [ -n "${6+set}" ]; then
      echo "Running command: docker run --name $project -d -p $ip:80:$port -p $ip:$port2:$port2 $docker"
      sudo docker run --name $project -d -p $ip:80:$port -p $ip:$port2:$port2 $docker
    else echo "not set";
      echo "Running command: docker run --name $project -d -p $ip:80:$port $docker"
      sudo docker run --name $project -d -p $ip:80:$port $docker
    fi
  fi
  echo "DONE!"
  echo
  echo "Docker mapped to http://$project or http://$ip"
  echo
}

new_app (){

}

remove_app (){

}

app_in() {
echo "That's a good choice. But what next ?"
sudo docker images
echo "Decide if you want to hack one of above"
case "$1" in
A)
echo "A. Stark to Hack"
hack_app
;;
B)
echo "B. Install New ?"
new_app 
;;
C)
echo "Remove Existing"
remove_app
;;
esac 
}

echo "Hello," $whoami

# Let's check for docker service #
echo "Let's use docker engine to run our applications. Checking for the docker systems... hang on"

if ! sudo service --status-all | grep -Fq "docker" > /dev/null 
then
	echo 
	echo "Docker engine isn't loaded to the machine yet. Don't worries mate, let's install it..."
  sudo apt-get update
  sudo apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
  echo Adding to sources.list
  echo "deb [arch=amd64] https://download.docker.com/linux/debian stretch stable" | sudo tee --append /etc/apt/sources.list > /dev/null
	sudo apt-get update
  sudo apt-get install docker-ce
  echo "Docker engine is installed, let's check it's service status"
  exit
fi

if sudo service docker status | grep inactive > /dev/null
then 
	echo "Docker is not running."
	echo -n "Do you want to start docker now (y/n)?"
	read answer
	if echo "$answer" | grep -iq "^y"; then
		sudo service docker start
	else
		echo "Technicality. Just try installing docker from the webpage. https://store.docker.com/search?type=edition&offering=community "
	fi
fi

echo "Ok cool!, hopefully docker service is up and running now"
echo

# switching the case for menu selection #
echo
echo "Now that we're on same page, hopefully!"
echo 
echo "Choose an option"
case "$1" in
a)
echo "a. App - Hack, Install, Remove"
app_in
;;
b)
echo "b. Update docker engine"
update
;;
c)
echo "c. I'm done for today"
exit()
;;
esac
























