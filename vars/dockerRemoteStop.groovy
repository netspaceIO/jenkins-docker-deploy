def call(Map config = [:]) {
  loadShellScript(name: 'remote-docker-stop.sh')
  // Execute the script within
  sshagent(credentials: [config.credentialsId]) {
    sh """
      ./remote-docker-stop.sh \
        -t ${config.host} \
        -u ${config.user} \
        -p ${config.port}
  }
}
