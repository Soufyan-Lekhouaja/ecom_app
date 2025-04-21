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
                    -p 3306:3306 mysql:8.0
                    '''
                }
            }
        }
        stage('Init Database') {
            steps {
                script {
                    // Attendre que MySQL soit prêt (tu peux ajuster à 20-30s si nécessaire)
                    bat 'sleep 60'
                    // Copier le fichier SQL dans le conteneur
                    bat 'docker cp scriptdb.sql mysql8:/scriptdb.sql'

                    // Exécuter le script dans la base ecomjava
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
