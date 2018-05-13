#!/bin/sh

port=2212
container_name='ppsi-sshd'

sudo docker stop "$container_name" 2> /dev/null && sudo docker rm -v "$container_name" 2> /dev/null
sudo docker run -d -p "$port:2222" --name "$container_name" --restart=always jae-ppsi-sshd #/usr/sbin/sshd -ddd

