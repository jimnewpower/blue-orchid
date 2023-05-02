pipeline {
  agent any

  stages {
    stage('Build') {
      steps {
        echo 'Building...'
        make clean
        sh build.sh
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
