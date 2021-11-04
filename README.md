# Jenkins-tf-docker-project-1

There's a script to install docker and jenkins on the Jenkins server
install git on that same server. - with this command - yum install git -y
You need to install Terraform in this same server because Jenkins needs that to run your terraform config


putting this here 
checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: '6ec14c9e-83ab-4b0e-b556-3ed7071c89e6', url: 'https://github.com/Kokostar25/Jenkins-tf-docker-project-1']]])
