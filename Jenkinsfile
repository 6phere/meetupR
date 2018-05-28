pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'printenv'
        slackSend(message: "${MODEL_NAME} deploying ...", channel: 'meetupr')
      }
    }
    stage('Delivery for release candidate branches') {
      when {
        expression {
          BRANCH_NAME ==~ /release\/.*/
        }

      }
      steps {
        script {
          RC_NAME = BRANCH_NAME.substring(BRANCH_NAME.indexOf('/') + 1)
          IMAGE_NAME = "6phr_${MODEL_NAME}:${RC_NAME}.${BUILD_NUMBER}"
          CONTAINER_NAME = "6phr_${MODEL_NAME}_${RC_NAME}.${BUILD_NUMBER}"
        }

        slackSend(message: "Building the image ${IMAGE_NAME} ... ", channel: 'meetupr')
        sh "docker build -t ${IMAGE_NAME} --build-arg api_path=rstudio/home/apis/${MODEL_NAME}-api.R  -f DockerfileApis ."
        slackSend(message: "Starting the container ${CONTAINER_NAME} ...", channel: 'meetupr')
        sh "docker run -it -d --name ${CONTAINER_NAME} -p 8000 ${IMAGE_NAME}"
        slackSend(message: "Release candidate ${RC_NAME} delivery done!", channel: 'meetupr')
      }
    }
    stage('Deploy master branch') {
      when {
        branch 'master'
      }
      steps {
        script {
          IMAGE_NAME = "6phr_${MODEL_NAME}:${MODEL_VERSION}.${BUILD_NUMBER}"
          CONTAINER_NAME = "6phr_${MODEL_NAME}_${MODEL_VERSION}"
        }

        slackSend(message: "Building the image ${IMAGE_NAME} ... ", channel: 'meetupr')
        sh "docker build -t ${IMAGE_NAME} --build-arg api_path=rstudio/home/apis/${MODEL_NAME}-api.R  -f DockerfileApis ."
        slackSend(message: "Starting the container ${CONTAINER_NAME} ...", channel: 'meetupr')
        sh "docker run -it -d --name ${CONTAINER_NAME} -p 8000 ${IMAGE_NAME}"
        slackSend(message: "Version ${MODEL_VERSION} delivery done!", channel: 'meetupr')
      }
    }
  }
  environment {
    MODEL_NAME = 'keras-mnist'
    MODEL_VERSION = '1.0'
  }
}
