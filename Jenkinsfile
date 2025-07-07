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

        stage('Scan Image with Trivy') {
            steps {
                script {
                    sh '''
                        if ! command -v trivy &> /dev/null; then
                            echo "Installing Trivy..."
                            wget -q https://github.com/aquasecurity/trivy/releases/download/v0.64.1/trivy_0.64.1_Linux-64bit.deb
                            dpkg -i trivy_0.64.1_Linux-64bit.deb
                        fi

                        echo "Running Trivy Scan..."
                        trivy image my-nginx-image
                    '''
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
    }
}
