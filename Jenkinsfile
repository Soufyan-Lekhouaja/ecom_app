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
        stage('Setup Network and MySQL') {
            steps {
                script {
                    // Créer le réseau Docker s’il n’existe pas
                    bat 'docker network inspect ecom-network || docker network create ecom-network'

                    // Stop + remove MySQL s’il existe déjà
                    bat 'docker stop mysql8 || exit 0'
                    bat 'docker rm mysql8 || exit 0'

                    // Lancer le conteneur MySQL
                    bat '''
                    docker run -d --name mysql8 --network ecom-network ^
                    -e MYSQL_ROOT_PASSWORD=1212 ^
                    -e MYSQL_DATABASE=ecomjava ^
                    -p 3306:3306 ^
                    -v %CD%/scriptdb.sql:/docker-entrypoint-initdb.d/scriptdb.sql ^
                    mysql:8.0
                    '''
                }
            }
        }
        stage('Init Database') {
    steps {
        script {
            // Verify file exists
            bat 'dir scriptdb.sql'
            
            // Wait for MySQL to be ready
            bat '''
            :loop
            docker exec mysql8 mysqladmin -uroot -p1212 ping | findstr "mysqld is alive" && goto :done
            timeout /t 5
            goto :loop
            :done
            '''
            
            // Copy the file
            bat 'docker cp scriptdb.sql mysql8:/scriptdb.sql'
            bat 'docker exec -i mysql8 mysql -uroot -p1212 ecomjava < /scriptdb.sql'
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
                    bat 'docker stop ecomapp || true'
                    bat 'docker rm ecomapp || true'
                    bat 'docker build -t ecomapp:latest .'
                }
            }
        }
        
        stage('Run Docker Container') {
            steps {
                script {
                    bat 'docker run -d -p 8083:8083 --name ecomapp --network ecom-network ecomapp:latest'
                }
            }
        }
    }
}
