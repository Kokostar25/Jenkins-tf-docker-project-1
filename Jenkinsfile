pipeline {
    agent any
    environment {
        registry = "726569704041.dkr.ecr.us-east-1.amazonaws.com/appimage"
        }

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
        stage ("Terraform plan") {
            steps {
                sh ("terraform plan");
            }
            
        }
        stage ("Terraform apply") {
            steps {
              sh ("terraform apply --auto-approve");
            }
        }
     }  
}
        
      
 
