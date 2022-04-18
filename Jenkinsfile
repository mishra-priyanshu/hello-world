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
                sshpass -p dockeradmin ssh  -o StrictHostKeyChecking=no  dockeradmin@172.31.3.204 << EOF
                tag=$(cat /proc/sys/kernel/random/uuid)
                cd /opt/docker-project 
                docker  rm -f $(docker ps -a -q) ;
                docker system prune  --force;
                docker image prune --force;
                docker build -t regapp:$tag . ;
                exit 0
                << EOF
                '''
            }
        }
        stage("Application Hosting"){
            steps{
                sh '''
                #!/bin/bash
                sshpass -p dockeradmin ssh  -o StrictHostKeyChecking=no  dockeradmin@172.31.3.204 << EOF
                docker run -d  --name  registerapp-$tag  -p  8082:8080  regapp:$tag ;
                exit 0
                << EOF
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
