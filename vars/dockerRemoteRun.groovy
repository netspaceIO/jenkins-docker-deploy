
// Run docker image to the remote host.
def call(Map config = [:]) {

  // Load shell script
  loadShellScript(name: "remote-run-docker-img.sh")

  withCredentials([file(credentialsId: config.env, variable: envFile)]) {
    sh ("""
      ./remote-run-docker-img.sh \
        -t ${config.host} \
        -u ${config.user} \
        -a ${config.app} \
        -p ${config.bindPort}:${config.containerPort} \
        -e ${config.envFile}
      ${config.img}
    """)
  }
}
