#!/bin/sh
set -eu

install -d /run/sshd
install -d -m 700 -o ansible -g ansible /home/ansible/.ssh
install -m 600 -o ansible -g ansible \
    /run/keys/ansible_test_server.pub /home/ansible/.ssh/authorized_keys

ssh-keygen -A
exec /usr/sbin/sshd -D -e -o PasswordAuthentication=no -o KbdInteractiveAuthentication=no