pipeline {
    agent any
    tools {
        maven 'Maven 3.9.9'
        jdk '17.0.12'
    }
    environment {
        DOCKER_COMPOSE_FILE = 'docker-compose.yml'
    }
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Soufyan-Lekhouaja/ecom_app', branch: 'master'
            }
        }
        stage('Build Application') {
            steps {
                bat 'mvn clean package -DskipTests'
            }
        }
        stage('Build Docker Image') {
            steps {
                bat 'docker build -t ecomapp-prod:latest .'
            }
        }
        stage('Deploy Application Container') {
            steps {
                bat "docker-compose -f ${env.DOCKER_COMPOSE_FILE} up -d --no-deps ecomapp-prod"
            }
        }
    }
    post {
        failure {
            echo 'Production deployment failed.'
        }
    }
}
