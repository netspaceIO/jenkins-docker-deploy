#!/usr/bin/env bash

############################################################
# Params                                                   #
############################################################
user=
host=
name=

############################################################
# Help function                                            #
############################################################
showHelp()
{
   # Display Help
   echo ""
   echo Stops a docker container by port
   echo
   echo "Syntax: $0 [-t|h|n|u]"
   echo "options:"
   echo "h     Print this Help."
   echo "n     Name of the docker stopped or running docker container"
   echo "t     Target SSH host running dockerd"
   echo "u     SSH user"
   echo
}

############################################################
# Process the input options. Add options as needed.        #
############################################################
while getopts ":hn:t:u:" option; do
   case $option in
      h) # display Help
         showHelp
         exit;;
      t) # Enter Target host
         host=$OPTARG;;
      n) # Enter port
         name=$OPTARG;;
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
docker --host "${url}" rm "${name}" -f >/dev/null 2>/dev/null
