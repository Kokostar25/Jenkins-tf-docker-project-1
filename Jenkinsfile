pipeline {
    agent any

    stages {
        stage('checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: '6ec14c9e-83ab-4b0e-b556-3ed7071c89e6', url: 'https://github.com/Kokostar25/Jenkins-tf-docker-project-1']]])
            }
        }
        
        stage ("Terraform init") {
            steps {
                sh ("terraform init");
            }
            
        }
        stage ("Terraform Action") {
            steps {
                echo "terraform acton from the parameter is --> ${action}"
                sh ("terraform ${action} --auto-approve");
            }
            
        }
    }
}