# Jenkins-tf-docker-project-1

There's a script to install docker and jenkins on the Jenkins server
install git on that same server. - with this command - yum install git -y
You need to install Terraform in this same server because Jenkins needs that to run your terraform config
Make sure you have git,docker & docker pipeline installed as well as its plugin, same for terraform -
specify the path on the jenkins console /usr/bin (make sure the terraform install is moved to this path)
Make sure you have created a role- The role shouls have polices - AmazonEC2FullAccess and AmazonEC2ContainerRegistryFullAccess
You might have permission issues with docker, you need to change user permissions using - sudo chmod 666 /var/run/docker.sock

