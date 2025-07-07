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
                    sh 'docker rm -f webserver01 || true'
                    sh 'docker run -d --name webserver01 -p 13001:80 my-nginx-image'
                }
            }
        }

        stage('Trivy Scan') {
            steps {
                script {
                    sh 'trivy image my-nginx-image'
                }
            }
        }
    }
}
