pipeline {
    agent any

    stages {
        stage('Clone Repo') {
            steps {
                git 'https://github.com/dexter73710/Myproject.git'
            }
        }

        stage('Deploy to Nginx Container') {
            steps {
                script {
                    // Copy index.html to Nginx container
                    sh '''
                    docker cp index.html webserver01:/usr/share/nginx/html/index.html
                    docker exec webserver01 nginx -s reload || true
                    '''
                }
            }
        }
    }
}
