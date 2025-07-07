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
                        # Install Trivy if not available
                        if ! command -v trivy &> /dev/null; then
                            echo "Installing Trivy..."
                            apt update && apt install -y wget gnupg2
                            wget -q https://github.com/aquasecurity/trivy/releases/download/v0.64.1/trivy_0.64.1_Linux-64bit.deb
                            dpkg -i trivy_0.64.1_Linux-64bit.deb
                        fi

                        # Download HTML template if missing
                        if [ ! -f html.tpl ]; then
                          wget https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/html.tpl
                        fi

                        # Run scan and generate HTML report
                        trivy image --format template --template "@html.tpl" -o trivy-report.html my-nginx-image
                    '''
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    sh 'docker rm -f webserver01 || true'
                    sh 'docker run -d --nam
