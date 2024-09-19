pipeline {
    agent any
    stages {
        stage('Deploy') {
            steps {
                sh "./deploy.bash ${params.CONTAINER_IP}"
            }
        }
    }
}
