#!/bin/bash
if [[ -n "$LOGIN" && ! $(id $LOGIN >/dev/null 2>&1) ]]; then
  if [[ -z "$HOMEDIR" ]]; then
    export HOMEDIR="/home/$LOGIN"
  fi
  useradd -u "$UID" -g "$GROUP" -G "$GROUPS" -d "$HOMEDIR" "$LOGIN"
  echo "$LOGIN:$PASSWORD" | chpasswd
fi

if [ ! -f "/etc/ssh/sshd_config" ];then
  cp -rp /app/ssh/* /etc/ssh/
fi
if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]; then
  ssh-keygen -A
fi
exec /usr/sbin/sshd -D
