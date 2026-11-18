#!/bin/sh
set -eu

install -d /run/sshd
install -d -m 700 -o jenkins -g jenkins /home/jenkins/.ssh
install -m 600 -o jenkins -g jenkins \
    /run/keys/jenkins_ansible_agent.pub /home/jenkins/.ssh/authorized_keys

ssh-keygen -A
exec /usr/sbin/sshd -D -e -o PasswordAuthentication=no -o KbdInteractiveAuthentication=no