#!/usr/bin/env bash

############################################################
# Params                                                   #
############################################################
user=
host=
port=

############################################################
# Help function                                            #
############################################################
showHelp()
{
   # Display Help
   echo ""
   echo Stops a docker container by port
   echo
   echo "Syntax: $0 [-t|h|p|u]"
   echo "options:"
   echo "h     Print this Help."
   echo "p     Container port"
   echo "t     Target SSH host running dockerd"
   echo "u     SSH user"
   echo
}

############################################################
# Process the input options. Add options as needed.        #
############################################################
while getopts ":hp:t:u:" option; do
   case $option in
      h) # display Help
         showHelp
         exit;;
      t) # Enter Target host
         host=$OPTARG;;
      p) # Enter port
         port=$OPTARG;;
      u) # Enter user
         user=$OPTARG;;
      *) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

url="ssh://${user}@${host}"

############################################################
# Process the input options. Add options as needed.        #
############################################################
for id in $(docker ps -aq)
do
    if [[ $(docker --host "${url}" port "${id}") == *"${port}"* ]]; then
        echo "stopping container ${id}"
        docker --host "${url}" rm "${id}" -f >/dev/null 2>/dev/null
    fi
done
