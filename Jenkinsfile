pipeline {
  agent any

  stages {
    stage('Build') {
      steps {
        echo 'Building...'
        sh 'make clean build'
      }
    }
    stage('Test') {
      steps {
        echo 'Testing...'
      }
    }
    stage('Package') {
      steps {
        echo 'Packaging...'
      }
    }
    stage('Deploy') {
      steps {
        echo 'Deploying...'
      }
    }
  }
}
