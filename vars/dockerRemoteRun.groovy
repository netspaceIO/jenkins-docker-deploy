
// Run docker image to the remote host.
def call(Map config = [:]) {

  // Load shell script
  loadShellScript(name: "remote-run-docker-img.sh")
  
  withCredentials([file(credentialsId: config.env, variable: "ENV_FILE")]) {
    
    if (config['bindVol'] && config['containerVol']) {
      sh ("""
      ./remote-run-docker-img.sh \
        -t ${config.host} \
        -u ${config.user} \
        -a ${config.app} \
        -v ${config.bindVol}:${config.containerVol} \
        -p ${config.bindPort}:${config.containerPort} \
        -e \${ENV_FILE} \
      ${config.img}
      """)
    } else {
      sh ("""
      ./remote-run-docker-img.sh \
        -t ${config.host} \
        -u ${config.user} \
        -a ${config.app} \
        -p ${config.bindPort}:${config.containerPort} \
        -e \${ENV_FILE} \
      ${config.img}
      """)
    }
  }
}
