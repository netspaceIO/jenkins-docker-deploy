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
while getopts "a:u:t:p:e:v:" opt; do
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
    v) volume=${OPTARG}
      ;;
  esac
done

shift $((OPTIND-1))
[ "${1:-}" = "--" ] && shift

# Stop previously launched container by image name (Works in docker 1.9+)
docker --host ssh://${user}@${host} ps -aqf "name=${appName}"

if [ -z ${volume+x} ];
then
  docker --host ssh://${user}@${host} run \
    --env-file ${envFile} \
    --name ${appName} \
    --publish ${publish} \
    --detach \
    --rm \
    --privileged $@
 else
   docker --host ssh://${user}@${host} run \
     --env-file ${envFile} \
     --name ${appName} \
     --volume ${volume} \
     --publish ${publish} \
     --detach \
     --rm \
     --privileged $@
fi
