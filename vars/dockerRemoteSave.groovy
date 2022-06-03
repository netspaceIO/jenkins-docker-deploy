// Push docker image to the remote host via SSH
def call(Map config = [:]) {
  sshagent(credentials: [credentialsId]) {
    sh'''
      [ -d ~/.ssh ] || mkdir ~/.ssh
      ssh-keyscan -t rsa,dsa ${config.host} >> ~/.ssh/known_hosts
      docker save ${config.img} | ssh -C ${config.user}@${config.host} docker load
    '''
  }
}
