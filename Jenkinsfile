pipeline {
  agent any

  environment {
    // You can define any environment variables here if needed
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/ShubhamRaj97/airbnb.git'
      }
    }

    stage('Build Docker Image') {
      steps {
        echo 'Building Docker image...'
        sh 'docker-compose build'
      }
    }

    stage('Precompile Assets') {
      steps {
        echo 'Precompiling assets...'
        sh 'docker-compose run web rake assets:precompile'
      }
    }

    stage('Run Tests') {
      steps {
        echo 'Running tests...'
        sh 'docker-compose run web rspec'
      }
    }

    stage('Up Containers') {
      steps {
        echo 'Starting containers...'
        sh 'docker-compose up -d'
      }
    }
  }

  post {
    always {
      echo 'Cleaning up'
      sh 'docker-compose down --volumes --remove-orphans || true'
    }
  }
}
