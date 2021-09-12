pipeline {
  agent any
  
  stages {
    stage('Build') {
      environment {
        DOCKERHUB_CREDS = credentials('dockerhub')
      }
      steps {
          // Build new image
          sh "until docker ps; do sleep 3; done && docker build -t invaleed/argo-hello:${env.GIT_COMMIT} ."
          // Publish new image
          sh "docker login --username $DOCKERHUB_CREDS_USR --password $DOCKERHUB_CREDS_PSW && docker push invaleed/argo-hello:${env.GIT_COMMIT}"
        }
    }

    stage('Deploy E2E') {
      environment {
        GIT_CREDS = credentials('git')
      }
      steps {
          sh "git clone https://$GIT_CREDS_USR:$GIT_CREDS_PSW@github.com/invaleed/argo-hello-deploy.git"
          sh "git config --global user.email 'ramadoni.ashudi@gmail.com'"

          dir("argo-hello-deploy") {
            sh "cd ./e2e && kustomize edit set image invaleed/argo-hello:${env.GIT_COMMIT}"
            sh "git commit -am 'Publish new version' && git push || echo 'no changes'"
          }
      }
    }

    stage('Deploy to Prod') {
      steps {
        input message:'Approve deployment?'
          dir("argo-hello-deploy") {
            sh "cd ./prod && kustomize edit set image invaleed/argo-hello:${env.GIT_COMMIT}"
            sh "git commit -am 'Publish new version' && git push || echo 'no changes'"
          }
      }
    }
  }
}
