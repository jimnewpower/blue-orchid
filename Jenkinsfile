pipeline {
  agent any

  tools {
    go 'go-1.11.4'
  }

  stages {
    stage('Build') {
      steps {
        echo 'Building...'
        sh 'cd src/main && GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ../../bin/main main.go'
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
