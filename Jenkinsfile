pipeline {
  agent any
  
  stages {
    stage('Build') {
      environment {
        DOCKERHUB_CREDS = credentials('dockerhub')
      }
      steps {
         sh "until docker ps; do sleep 3; done && docker build -t invaleed/argo-hello-nogitops:${env.GIT_COMMIT} ."
         sh "docker login --username $DOCKERHUB_CREDS_USR --password $DOCKERHUB_CREDS_PSW && docker push invaleed/argo-hello-nogitops:${env.GIT_COMMIT}"
      }
    }

    stage('Deploy E2E') {
      environment {
        GIT_CREDS = credentials('git')
      }
      steps {
	sh "git clone https://$GIT_CREDS_USR:$GIT_CREDS_PSW@github.com/invaleed/argo-hello-nogitops.git"
	sh "sed -i 's/commitid/${env.GIT_COMMIT}/g' manifests/e2e/deployment.yml"
        sh "kubectl apply -f manifests/e2e/deployment.yml -n nogitops-e2e"
	sh "kubectl apply -f manifests/e2e/service.yml -n nogitops-e2e"
      }
    }

    stage('Deploy to Prod') {
      steps {
	sh "sed -i 's/commitid/${env.GIT_COMMIT}/g' manifests/prod/deployment.yml"
        sh "kubectl apply -f manifests/prod/deployment.yml -n nogitops-prod"
	sh "kubectl apply -f manifests/prod/service.yml -n nogitops-prod"
      }
    }
  }
}
