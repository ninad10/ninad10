#!/bin/bash

#Create HDFS User
echo 'Enter HDFS Username to be created : '

read user

#Create HDFS User
sudo su - hdfs -c "hdfs dfs -mkdir /user/$user"

#Change ownership of HDFS User
echo 'Eneter HDFS Group to associate for user' $user ':'

read group

#Change ownership of HDFS user

sudo su - hdfs -c "hdfs dfs -chown -R $user:$group /user/$user"

echo 'Success'

exit
