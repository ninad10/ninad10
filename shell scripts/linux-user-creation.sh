#!/bin/bash

#Take username from stdin
echo 'Enter Username :'

read username

#Create user
useradd $username

#Modidy/Assign group
echo 'Enter Group( admin or developer) to assign to' $username ':'

read group

usermod -a -G $group $username

#Create .ssh and authkeys
sudo su - $username -c "mkdir /home/$username/.ssh"

sudo su - $username -c "touch /home/$username/.ssh/authorized_keys"


#Enter public key
echo Enter Public key for $username :

read pubkey

sudo su - $username -c "echo $pubkey >> /home/$username/.ssh/authorized_keys"

#Change permissions of .ssh and auth keys

sudo su - $username -c "chmod 700 /home/$username/.ssh"

sudo su - $username -c "chmod 600 /home/$username/.ssh/authorized_keys"

echo 'Success'

exit
