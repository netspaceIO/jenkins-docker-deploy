# jenkins-docker-deploy
A Jenkins shared library for deploying to a remote host via SSH

### Motive

In most cases, a delivery task is needed in order to deliver docker image to the remote host and then deploy the image through `docker run` command.
Aim of this project is to automate delivery and deployment of docker containers from your Jenkins server to the prod, test or dev server.

### Pre-requisites

You need to configure
* SSH Credentials on your jenkins controller (A server which you've deployed your Jenkins)
* Add your public key (e.g., `id_rsa.pub` or `id_dsa.pub`) to the `authorized_keys` of the deployment server.
* Install SSH agent plugin on your Jenkins
* Configure the library in your Jenkins installation

### Using the shared library

In your Jenkins, use the library as following

```jenkins
// Declarative pipeline
@Library('<name of your this library in your config>') _

pipeline {

  agent any

  environment {
    DOCKER_IMG     = "my-img"              // The image to push
    SSH_USER       = "app-user"            // SSH user 
    CREDENTIALS_ID = "ssh-key-id"          // ID of the credentials
  }

  stages {

    stage("Build") {
      steps {
        // Build the image
        // sh "docker stop ${env.DOCKER_IMG} "
        // sh "docker rm -f ${env.DOCKER_IMG} "
        sh "docker build -t ${env.DOCKER_IMG} ."
      }
    }

    stage("Deliver") {

      environment {
        SSH_HOST = "your host address"
      }

      steps {
        // This will push the image `env.DOCKER_IMG` to the deployment host
        dockerRemoteSave(credentialsId: env.CREDENTIALS_ID, img: env.DOCKER_IMG, host: env.SSH_HOST, user: SSH_USER)
      }
    }

    
  
    stage("Deploy") {

      environment {
        BIND_PORT      = 5000   // Your bind port - Exposed to other services public
        CONTAINER_PORT = 3333   // Container port - Not accessible to other service
        APP_NAME       = "my-app"
        ENV_FILE_ID    = "my-env" // Your env file
        SSH_HOST       = "your-target-host" // Target server
      }

      steps {

        // Stop previous container by port (if any)
        dockerRemoteStop(
          host: "${env.SSH_HOST}",
          user: "${env.SSH_USER}",
          name: "${env.APP_NAME}",
          credentialsId: "${env.CREDENTIALS_ID}"
        )

        // Run the image to create a container
        dockerRemoteRun(
          host: "${env.SSH_HOST}",
          user: "${env.SSH_USER}",
          img: "${env.DOCKER_IMG}",
          bindPort: "${env.BIND_PORT}",
          containerPort: "${env.CONTAINER_PORT}",
          app: "${env.APP_NAME}",
          env: "${env.ENV_FILE_ID}"
        )
      }
    }
  }
}
```
