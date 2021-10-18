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
        stage ("Docker Job") {
            steps {
              sh ("pwd")
                dir ('webcontent/Dockerfile'){
                 sh "pwd";  
                }
                
            }
        }
 
        stage ('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Kokostar25/webcontent-docker']]])
            }
        }
        stage ('Docker Build') {
            steps {
                 script {
                     dockerImage = docker.build registry
        }
                
            }
        }
        stage ('Docker Push') {
            steps {
                script {
                    sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 726569704041.dkr.ecr.us-east-1.amazonaws.com'
                    sh 'docker push 726569704041.dkr.ecr.us-east-1.amazonaws.com/appimage:latest'
                }
            }
        }
        stage ('stop previous containers') {
            steps {
                sh 'docker ps -f name=myappimageContainer -q | xargs --no-run-if-empty docker container stop'
                sh 'docker container ls -a -fname=myappimageContainer -q | xargs -r docker container rm'
            }
       }
       stage ('Docker Run') {
            steps{
                script {
                    sh 'docker run -d -p 8096:3000 --rm --name myappimageContainer 726569704041.dkr.ecr.us-east-1.amazonaws.com/appimage:latest'
                }
            }
        }
    }
}    
