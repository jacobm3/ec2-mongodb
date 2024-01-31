#!/bin/bash

hostnamectl set-hostname "${hostname}"

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get upgrade -y
apt-get install -y \
  bzip2 \
  curl \
  git \
  gnupg \
  htop \
  iotop \
  jq \
  net-tools \
  netcat \
  nmap \
  python3-pip \
  sysstat \
  tree \
  unzip \
  vim-nox 

# install mongo
curl -fsSL https://pgp.mongodb.com/server-7.0.asc | \
   gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor

# broken in mongo's install docs:
# echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.com/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list


# correct
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list


apt-get update
apt-get install -y mongodb-org


cat > /etc/mongod.conf <<EOF
storage:
  dbPath: /var/lib/mongodb

systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log

net:
  port: 27017
  bindIp: 0.0.0.0

processManagement:
  timeZoneInfo: /usr/share/zoneinfo

EOF



systemctl daemon-reload
systemctl enable mongod
systemctl start mongod
systemctl status mongod

# wait for mongo to start and warm up
until echo "exit;" | mongosh; do sleep 1; done
sleep 10

mongosh <<EOF
use admin
db.createUser({ user: "admin", pwd: "${password}", roles: ["root"] })
exit;
EOF

