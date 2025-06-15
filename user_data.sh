#!/bin/bash
sudo apt update -y
sudo apt remove -y openjdk-*

# Install Azul JDK 21
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys B1998361219BD9C9
sudo apt-add-repository 'deb https://repos.azul.com/zulu/deb stable main' -y
sudo apt update -y
sudo apt install -y zulu21-jdk

# Verify Java 21
java -version

# Clone repo and build
cd /home/ubuntu
git clone ${repo_url} app
cd app

chmod +x ./mvnw
./mvnw clean package -DskipTests

# Find JAR
JAR=$(find target -name "*.jar" | head -n 1)

# Run on port 80
sudo java -jar "$JAR" --server.port=80 --server.address=0.0.0.0 > output.log 2>&1 &
