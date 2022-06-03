#!/bin/sh

# A POSIX variable
OPTIND=1 # Reset in case getopts has been used previously in the shell.

# Variables
user=""
host=""

# Read commandline args
while getopts "u:t:" opt; do
  case "${opt}" in
    u) user=${OPTARG}
      ;;
    t) host=${OPTARG}
      ;;
  esac
done

shift $((OPTIND-1))
[ "${1:-}" = "--" ] && shift

echo "Image: $@, Host: $host, User: $user"

# Add SSH keys to the known host
[ -d ~/.ssh ] || mkdir ~/.ssh
ssh-keyscan -t rsa,dsa "${host}" >> ~/.ssh/known_hosts

# Check if the last command was successful
# and use SSH to upload image to the target
if [ $? -eq 0 ]; then
  docker save $@ | ssh -C ${user}@${host} docker load
else
  echo "Failed to upload image"
  exit -1
fi
