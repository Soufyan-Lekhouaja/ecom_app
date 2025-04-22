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
        stage('Deploy MySQL8') {
            steps {
                script {
                    // Stop any existing containers to avoid conflicts
                    bat 'docker-compose -f docker-compose.yml down || echo "No existing containers to stop"'
                    // Start only the mysql8 service
                    bat 'docker-compose -f docker-compose.yml up -d mysql8'
                    // Wait for MySQL8 to be healthy
                    bat '''
                    :loop
                    docker exec mysql8 mysqladmin -uroot -p1212 ping | findstr "mysqld is alive" && goto :done
                    timeout /t 5
                    goto :loop
                    :done
                    '''
                    // Verify database schema
                    bat 'docker exec mysql8 mysql -uroot -p1212 ecomjava -e "SHOW TABLES"'
                }
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
                    bat 'docker build -t ecomapp:latest .'
                }
            }
        }
        stage('Deploy ecomapp') {
            steps {
                script {
                    // Deploy ecomapp service (mysql8 is already running)
                    bat 'docker-compose -f docker-compose.yml up -d ecomapp'
                }
            }
        }
        stage('Health Check') {
            steps {
                script {
                    // Verify ecomapp is running
                    bat 'curl -f http://localhost:8083 || exit 1'
                }
            }
        }
    }
    post {
        failure {
            echo "Pipeline failed! Check container logs:"
            bat 'docker logs mysql8'
            bat 'docker logs ecomapp'
        }
        success {
            echo "Application successfully deployed"
        }
    }
}
