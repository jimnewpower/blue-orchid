pipeline {
  agent any

  stages {
    stage('Build') {
      steps {
        echo 'Building...'
        sh 'go build -o main'
      }
    }
    stage('Test') {
      steps {
        echo 'Testing...'
        sh 'go test ./...'
      }
    }
    stage('Package') {
      steps {
        echo 'Packaging...'
        sh 'zip deployment.zip main'
      }
    }
    stage('Deploy') {
      steps {
        echo 'Deploying...'
        sh 'terraform init'
        sh 'terraform plan'
      }
    }
  }
}
