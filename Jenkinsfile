pipeline {
    agent any

    stages {
        stage('Clone Repo') {
            steps {
                git 'https://github.com/dexter73710/Myproject.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t my-nginx-image .'
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    // Remove old container if it exists
                    sh 'docker rm -f webserver01 || true'

                    // Run the new container
                    sh 'docker run -d --name webserver01 -p 13001:80 my-nginx-image'
                }
            }
        }
    }
}
