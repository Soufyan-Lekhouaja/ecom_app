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
        stage('ScrutationSCM') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                bat 'mvn clean install -DskipTests'
            }
        }

        stage('Tests') {
            parallel {
                stage('Tests Unitaires') {
                    steps {
                        bat 'mvn test'
                    }
                }
                
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

        stage('Deployment') {
            parallel {
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
                            bat "docker rm -f %CONTAINER_NAME% || exit 0"
                            bat "docker run -d --name %CONTAINER_NAME% -p 8083:8083 %DOCKER_IMAGE%"
                        }
                    }
                }
            }
        }
    }
}
