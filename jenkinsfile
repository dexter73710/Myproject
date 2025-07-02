pipeline {
    agent any

    stages {
        stage('Clone Repo') {
            steps {
                git 'https://github.com/dexter73710/Myproject.git'
            }
        }

        stage('Deploy to Nginx Directory') {
            steps {
                script {
                    // Adjust this path if Nginx serves a different location
                    def deployPath = '/var/www/Myproject'
                    
                    // Remove old files
                    sh "sudo rm -rf ${deployPath}/*"

                    // Copy new files
                    sh "sudo cp -r * ${deployPath}/"
                }
            }
        }

        stage('Reload Nginx') {
            steps {
                sh "sudo systemctl reload nginx"
            }
        }
    }
}
