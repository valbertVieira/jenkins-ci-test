pipeline {
    agent any
    
    stages {
        stage('Generate Environment File') {
            steps {
                // Adicione permissões ao script se necessário
                sh 'chmod +x ./scripts/build.bash'
                // Executa o script que gera o .env com as variáveis de ambiente
                sh 'bash ./scripts/build.bash'
                // Opcional: Verifica o conteúdo do .env para garantir que foi gerado corretamente
                sh 'cat .env'
            }
        }
        
        stage('Deploy to Remote Container') {
            steps {
                // Adicione permissões ao script de deploy se necessário
                sh 'chmod +x ./deploy.bash'
                // Executa o script de deploy que copia os arquivos para o container remoto e inicia o serviço
                sh 'bash ./deploy.bash ${params.CONTAINER_IP}'
            }
        }
    }
    
    post {
        always {
            // Limpeza ou ações pós-build, se necessário
            echo "Pipeline concluído, executando ações pós-build."
        }
    }
}
