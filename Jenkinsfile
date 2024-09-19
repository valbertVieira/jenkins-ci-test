pipeline {
    agent any
    stages {
        stage('Deploy') {
            steps {
                sh 'chmod +x ./deploy.bash'
                sh "./deploy.bash ${params.CONTAINER_IP}"
            }
        }
    }
}
