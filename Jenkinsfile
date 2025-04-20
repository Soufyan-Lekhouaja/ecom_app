pipeline {
    agent any
    environment {
        MAVEN_HOME = 'C:\Program Files\Apache\maven-3.9.9'
        DOCKER_IMAGE = 'ecomapp:latest'
    }
    tools {
        maven 'Maven 3.9.9'
        jdk 'JDK 17'
    }
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/Soufyan-Lekhouaja/ecom_app'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean install'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Package') {
            steps {
                sh 'mvn package'
            }
        }
        stage('Publish to Nexus') {
            steps {
                sh 'mvn deploy'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t ecomapp:latest .'
                }
            }
        }
        stage('Run Docker Container') {
            steps {
                sh 'docker run -d -p 8080:8080 --name ecomapp ecomapp:latest'
            }
        }
    }
    post {
        failure {
            mail to: 'soufyan.lekhouaja@gmail.com',
                 subject: "ECHEC dans le pipeline Jenkins : ${env.JOB_NAME}",
                 body: "Le job ${env.JOB_NAME} a échoué à l'étape ${env.STAGE_NAME}.\nConsultez Jenkins pour plus de détails."
        }
    }
}
