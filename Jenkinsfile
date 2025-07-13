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
                sh 'docker build -t my-nginx-image .'
            }
        }

        stage('Trivy Scan & Report') {
            steps {
                sh '''#!/bin/bash
                    set -e
                    apt update && apt install -y wget gnupg2 dpkg

                    # Install Trivy
                    wget -q https://github.com/aquasecurity/trivy/releases/download/v0.64.1/trivy_0.64.1_Linux-64bit.deb
                    dpkg -i trivy_0.64.1_Linux-64bit.deb

                    # Get HTML template
                    wget -q -O html.tpl https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/html.tpl

                    # Scan and generate report
                    trivy image --format template --template "@html.tpl" -o trivy-report.html my-nginx-image
                '''
            }
        }

        stage('SonarQube Scan') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh 'sonar-scanner'
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                sh '''
                    docker rm -f webserver01 || true
                    docker run -d --name webserver01 -p 13001:80 my-nginx-image
                '''
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'trivy-report.html', fingerprint: true
            publishHTML([
                reportName : 'Trivy Vulnerability Report',
                reportDir  : '.',
                reportFiles: 'trivy-report.html',
                keepAll    : true
            ])
        }
    }
}
