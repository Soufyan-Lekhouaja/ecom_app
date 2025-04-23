pipeline {
    agent any

    environment {
        MAVEN_HOME = 'C:\\Program Files\\Apache\\maven-3.9.9'
        DOCKER_IMAGE = 'ecomapp:latest'
        CONTAINER_NAME = 'ecomapp_container'
    }

    tools {
        maven 'Maven 3.9.9'
        jdk '17.0.12'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Soufyan-Lekhouaja/ecom_app', branch: 'featuresDev'
            }
        }

        stage('Build') {
            steps {
                bat 'mvn clean install -DskipTests'
            }
        }

        stage('Test') {
            steps {
                bat 'mvn test'
            }
        }

        stage('Analyse du code') {
            parallel {
                stage('PMD') {
                    steps {
                        bat 'mvn pmd:pmd'
                    }
                }
            }
        }

        stage('JavaDoc') {
            steps {
                bat 'mvn javadoc:javadoc'
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
                    bat "docker build -t %DOCKER_IMAGE% ."
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    // Optional: Stop and remove old container if exists
                    bat "docker rm -f %CONTAINER_NAME% || exit 0"
                    bat "docker run -d --name %CONTAINER_NAME% -p 8083:8083 %DOCKER_IMAGE%"
                }
            }
        }
    }
}
