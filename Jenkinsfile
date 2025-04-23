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
        stage('Test'){
            steps {
                bat 'mvn test'
            }
        }
        stage('Analyse du code') {
            parallel {
                stage('Checkstyle') {
                    steps {
                        sh 'mvn checkstyle:checkstyle'
                        recordIssues tools: [checkStyle()]
                        echo 'Running Checkstyle for ecomapp'
                    }
                }
                stage('FindBugs') {
                    steps {
                        sh 'mvn findbugs:findbugs'
                        recordIssues tools: [findBugs()]
                        echo 'Running FindBugs for ecomapp'
                    }
                }
                stage('PMD') {
                    steps {
                        sh 'mvn pmd:pmd'
                        recordIssues tools: [pmdParser()]
                        echo 'Running PMD for ecomapp'
                    }
                }
            }
        stage('Build Docker Image') {
            steps {
                bat 'docker build -t ecomapp:latest .'
            }
        }
        stage('Deploy Application Container') {
            steps {
                bat "docker-compose -f ${env.DOCKER_COMPOSE_FILE} up -d --no-deps ecomapp"
            }
        }
    }
    post {
        failure {
            echo 'Production deployment failed.'
        }
    }
}
