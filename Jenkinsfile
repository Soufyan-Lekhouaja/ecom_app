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
        stage('Cleanup Old Container') {
            steps {
                bat 'docker rm -f ecomapp || echo "No existing container to remove"'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    bat 'docker build -t ecomapp:latest .'
                }
            }
        }
       stage('Run Docker Container') {
    steps {
        script {
            // Wait for MySQL to be ready
            bat '''
            :loop
            docker exec mysql8 mysqladmin -uroot -p1212 ping | findstr "mysqld is alive"
            if %ERRORLEVEL% NEQ 0 (
                timeout /t 5
                goto loop
            )
            echo MySQL is ready.
            '''

            // Run ecomapp container connected to the same network
            bat '''
            docker run -d --name ecomapp --network ecom-network ^
            -e SPRING_DATASOURCE_URL=jdbc:mysql://mysql8:3306/ecomjava ^
            -e SPRING_DATASOURCE_USERNAME=root ^
            -e SPRING_DATASOURCE_PASSWORD=1212 ^
            -e useSSL=false ^
            -p 8083:8083 ecomapp:latest
            '''
        }
    }
}
}
}
