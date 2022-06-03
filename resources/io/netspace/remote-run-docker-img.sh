#!/bin/sh

# A POSIX variable
OPTIND=1 # Reset in case getopts has been used previously in the shell.

# Variables
user=""
host=""
publish=""
appName=""
envFile=""

# Read commandline args
while getopts "u:t:" opt; do
  case "${opt}" in
    u) user=${OPTARG}
      ;;
    t) host=${OPTARG}
      ;;
    p) publish=${OPTARG}
      ;;
    a) appName=${OPTARG}
      ;;
    e) envFile=${OPTARG}
      ;;
  esac
done

shift $((OPTIND-1))
[ "${1:-}" = "--" ] && shift

# Stop previously launched container by image name (Works in docker 1.9+)
docker --host ${user}@${host} ps -aqf "name=${appName}" \
    | xargs -r docker --host ${host} stop
docker --host ${user}@${host} run \
    --env-file ${envFile}
    --name {config.appName} \
    --publish ${publish} \
    --detach \
    --rm \
    --privileged $@