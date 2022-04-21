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
        stage("Copy to Docker Host"){
            steps{
                sh 'sshpass -p dockeradmin scp  -o StrictHostKeyChecking=no  Dockerfile dockeradmin@172.31.3.204:/opt/docker-project'
                sh 'sshpass -p dockeradmin scp  -o StrictHostKeyChecking=no  webapp/target/*.war dockeradmin@172.31.3.204:/opt/docker-project'
            }
        }
        stage("Build Docker Image"){
            steps{
                sh '''
                #!/bin/bash
                sshpass -p ansadmin ssh  -o StrictHostKeyChecking=no  ansadmin@172.31.94.194 << EOF
                cd /opt/docker;
                ansible-playbook registerapp.yaml;
                sshpass -p ansadmin ssh  -o StrictHostKeyChecking=no  ansadmin@172.31.3.204;
                docker image ls;
                '''
            }
        }
        stage("Application Hosting"){
            steps{
                sh '''
                #!/bin/bash
                sshpass -p ansadminadmin ssh  -o StrictHostKeyChecking=no  ansadmin@172.31.94.194 << EOF
                ansible-playbook deploy_registerapp.yaml;
                sshpass -p ansadminadmin ssh  -o StrictHostKeyChecking=no  ansadmin@172.31.3.204;
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
