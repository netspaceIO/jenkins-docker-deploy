// Push docker image to the remote host via SSH
def call(Map config = [:]) {
  loadShellScript(name: 'remote-save-docker-img.sh')
  // Execute the script within
  sshagent(credentials: [config.credentialsId]) {
    sh """
      ./remote-save-docker-img.sh \
        -t ${config.host} \
        -u ${config.user} \
      ${config.img}"""
  }
}
