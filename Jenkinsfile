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

        stage('Install Trivy & Generate Report') {
            steps {
                script {
                    sh '''#!/bin/bash
                        set -e

                        echo "Installing dependencies..."
                        apt-get update && apt-get install -y wget gnupg2 dpkg

                        echo "Downloading Trivy..."
                        wget -q https://github.com/aquasecurity/trivy/releases/download/v0.50.2/trivy_0.50.2_Linux-64bit.deb
                        dpkg -i trivy_0.50.2_Linux-64bit.deb

                        echo "Downloading HTML template..."
                        wget -q -O html.tpl https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/html.tpl

                        echo "Running Trivy scan..."
                        trivy image --format template --template "@html.tpl" -o trivy-report.html my-nginx-image
                    '''
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    sh '''#!/bin/bash
                        docker rm -f webserver01 || true
                        docker run -d --name webserver01 -p 13001:80 my-nginx-image
                    '''
                }
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
