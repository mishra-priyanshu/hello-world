pipeline{
    agent any
    environment {
        PATH = "/opt/maven/bin:$PATH"
    }
    
    stages{
        stage('Clone'){
            steps{
                git url: 'https://github.com/mishra-priyanshu/hello-world.git', branch: 'master'
            }
        }
        stage('Build'){
            steps{
                
                sh 'mvn clean package'
            }
        }
        stage("Ansible - Build Docker Image"){
            steps{
                sh '''
                #!/bin/bash
                sshpass -p ansadmin ssh  -o StrictHostKeyChecking=no  ansadmin@172.31.94.194 << EOF
                ansible-playbook  /opt/docker/registerapp.yaml;
                sshpass -p ansadmin ssh  -o StrictHostKeyChecking=no  ansadmin@172.31.3.204;
                docker image ls;
                '''
            }
        }
        stage("Ansible - Application Hosting"){
            steps{
                sh '''
                #!/bin/bash
                sshpass -p ansadmin ssh  -o StrictHostKeyChecking=no  ansadmin@172.31.94.194 << EOF
                ansible-playbook  /opt/docker/deploy_registerapp.yaml;
                sshpass -p ansadmin ssh  -o StrictHostKeyChecking=no  ansadmin@172.31.3.204;
                docker ps ;
                '''
            }
        }
        stage("Application Status"){
            steps{
                sh 'echo Application Successfully hosted'
            }
        }
        
    }
}
