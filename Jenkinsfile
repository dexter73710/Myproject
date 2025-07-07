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

        stage('Scan Image with Trivy') {
            steps {
                sh '''#!/bin/bash
                    set -e

                    # Install Trivy if not already installed
                    if ! command -v trivy &> /dev/null; then
                        echo "Installing Trivy..."
                        apt update && apt install -y wget gnupg2
                        wget -q https://github.com/aquasecurity/trivy/releases/download/v0.64.1/trivy_0.64.1_Linux-64bit.deb
                        dpkg -i trivy_0.64.1_Linux-64bit.deb
                    fi

                    # Download HTML report template
                    wget -q -O html.tpl https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/html.tpl

                    # Run Trivy scan and generate HTML report
                    trivy image --format template --template "@html.tpl" -o trivy-report.html my-nginx-image
                '''
            }
        }

        stage('Run Docker Container') {
            steps {
                sh '''#!/bin/bash
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
                keepAll: true
            ])
        }
    }
}
