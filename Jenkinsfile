pipeline {
    agent any
    environment {
        MAVEN_HOME = 'C:\\Program Files\\Apache\\maven-3.9.9'
        DOCKER_IMAGE = 'ecomapp:latest'
    }
    tools {
        maven 'Maven 3.9.9'
        jdk '17.0.12'
    }
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/Soufyan-Lekhouaja/ecom_app'
            }
        }
        stage('Build') {
            steps {
                bat 'mvn clean install'
            }
        }
        stage('Test') {
            steps {
                bat 'mvn test'
            }
        }
        stage('Package') {
            steps {
                bat 'mvn package'
            }
        }
        stage('Publish to Nexus') {
            steps {
                bat 'mvn deploy'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    bat 'docker stop ecomapp'
                    bat 'docker rm ecomapp'
                    bat 'docker build -t ecomapp:latest .'
                }
            }
        }
        stage('Run Docker Container') {
            steps {
                bat 'docker run -d -p 8080:8083 --name ecomapp ecomapp:latest'
            }
        }
    }
    
}
