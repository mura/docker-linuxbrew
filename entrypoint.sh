#!/bin/bash

create_user () {
  if [[ -z "$LOGIN" ]]; then
    return
  fi
  if $(id $LOGIN >/dev/null 2>&1); then
    return
  fi

  [ -f /app/initialize.sh ] && source /app/initialize.sh
  if [[ -z "$HOMEDIR" ]]; then
    export HOMEDIR="/home/$LOGIN"
  fi
  useradd -u "$UID" -g "$GROUP" -G "$GROUPS" -d "$HOMEDIR" -s "$LOGIN_SHELL" "$LOGIN"
  echo "$LOGIN:$PASSWORD" | chpasswd
}

create_user

if [ ! -f "/etc/ssh/sshd_config" ];then
  cp -rp /app/ssh/* /etc/ssh/
fi
if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]; then
  ssh-keygen -A
fi
exec /usr/sbin/sshd -D
