#!/bin/bash
apt update -y
apt install -y docker.io
systemctl enable docker
systemctl start docker
docker run -d -p 80:80 --name nginx --restart always nginx
