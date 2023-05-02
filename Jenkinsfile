pipeline {
  agent any

  tools {
    go 'go-1.20'
  }

  stages {
    stage('Build') {
      steps {
        echo 'Building...'
        sh 'cd src/main && GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ../../bin/main main.go'
        sh 'chmod +x bin/main'
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
        sh 'cd deploy && terraform init && terraform plan -auto-approve'
      }
    }
    stage('Deploy') {
      steps {
        echo 'Deploying...'
      }
    }
  }
}
