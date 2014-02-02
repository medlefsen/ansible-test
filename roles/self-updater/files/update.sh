#!/bin/bash

if [[ "$#" -ne 1 || ( "$1" != build && "$1" != runtime ) ]]
then
  echo 1>&2 "Usage: $0 build"
  echo 1>&2 "       $0 runtime"
  exit 1
fi

if [ ! -e /etc/ansible/source ]
then
  echo 1>&2 "Missing /etc/ansible/source file"
  exit 2
fi

if [ ! -e /etc/ansible/groups ]
then
  > /etc/ansible/groups
fi

if [ -e /root/ansible ]
then
  cd /root/ansible
  git pull -f origin master
else
  git clone `< /etc/ansible/source` /root/ansible
  cd /root/ansible
fi

flags=()
if [ "$1" = build ]
then
  flags=(--skip-tags=runtime)
fi

ansible-playbook "${flags[@]}" /root/ansible/site.yml
