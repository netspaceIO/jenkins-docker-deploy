
// Run docker image to the remote host.
def call(Map config = [:]) {
  withCredentials([file(credentialsId: config.env, variable: envFile)]) {
    sh ('''#!/usr/bin/env bash
      # Stop previously launched container by image name (Works in docker 1.9+)
      docker --host ${config.sshUrl} ps -aqf "name=${config.appName}" \
          | xargs -r docker --host ${config.sshUrl} stop
      docker --host ${config.sshUrl} run \
          --env-file ${envFile}
          --name {config.appName} \
          --publish ${config.bindPort}:${config.containerPort} \
          --detach \
          --rm \
          --privileged \
      ${config.img}
    ''')
  }
}
