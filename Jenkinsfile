pipeline {
    agent any

    environment {
        SONAR_TOKEN = credentials('SONARQUBE_TOKEN')
    }

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

                    wget -q https://github.com/aquasecurity/trivy/releases/download/v0.64.1/trivy_0.64.1_Linux-64bit.deb
                    dpkg -i trivy_0.64.1_Linux-64bit.deb

                    wget -q -O html.tpl https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/html.tpl
                    trivy image --format template --template "@html.tpl" -o trivy-report.html my-nginx-image
                '''
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh """
                        sonar-scanner \
                        -Dsonar.projectKey=big-bird \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=http://localhost:9000 \
                        -Dsonar.login=$SONAR_TOKEN
                    """
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
                reportName: 'Trivy Vulnerability Report',
                reportDir: '.',
                reportFiles: 'trivy-report.html',
                keepAll: true,
                allowMissing: true,
                alwaysLinkToLastBuild: true
            ])
        }
    }
}
