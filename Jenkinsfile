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
                    sh '''
                    docker cp . webserver01:/usr/share/nginx/html/
                    docker exec webserver01 nginx -s reload || true
                    '''
                }
            }
        }
    }
}
