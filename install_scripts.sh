#!/bin/bash

printf "*** Hadoop & Spark Setup ***\n"

printf "This script installs the following applications: "
printf "1. Java JDK\n2. Hadoop\n3. Scala\n4. Spark\n"

printf "1. Java JDK\n"
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz
printf "\nComplete!\n"

printf "2. Hadoop\n"
wget http://www.apache.org/dyn/closer.cgi/hadoop/common/hadoop-2.8.0/hadoop-2.8.0.tar.gz
printf "\nComplete!\n"

printf "3. Scala\n"
wget https://downloads.lightbend.com/scala/2.12.2/scala-2.12.2.tgz
printf "\nComplete!\n"

printf "4. Spark\n"
wget http://d3kbcqa49mib13.cloudfront.net/spark-2.1.1-bin-hadoop2.7.tgz

printf "\nDownloads complete....\n"

printf "Installing downloaded applications...\n"

printf "Installing Java JDK\n"
sudo tar -xvzf jdk-8u131-linux-x64.tar.gz
ln -s jdk1.8.0_131 jdk

printf "Installing Hadoop\n"
sudo tar -xvzf hadoop-2.8.0.tar.gz
ln -s hadoop-2.8.0 hadoop

printf "Installing Scala\n"
sudo tar -xvzf scala-2.12.2.tgz
ln -s scala-2.12.2 scala

printf "Installing Spark\n"
sudo tar -xvzf spark-2.1.1-bin-hadoop2.7.tgz
ln -s spark-2.1.1-bin-hadoop2.7 spark


printf "Updating environment paths...\n"

echo 'export PATH=~/hadoop/bin:~/hadoop/sbin:~/jdk/bin:~/scala/bin:~/spark/bin:$PATH' >> ~/.bashrc
echo 'export HADOOP_HOME=~/hadoop' >> ~/.bashrc
echo 'export JAVA_HOME=~/jdk' >> ~/.bashrc
echo 'export SCALA_HOME=~/scala' >> ~/.bashrc
echo 'export SPARK_HOME=~/spark' >>~/.bashrc
echo

source ~/.bashrc

java -version
echo
hadoop version
echo
scala -version
echo

printf "Setup complete...!\n"
