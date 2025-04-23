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
                git url: 'https://github.com/Soufyan-Lekhouaja/ecom_app' , branch:'featuresDev'
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

        stage('Start the app') {
            steps {
                bat 'java -jar target/ecomapp.jar'
            }
        }
    }
}
