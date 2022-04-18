pipeline{
    agent any
    environment {
        PATH = "/opt/maven/bin:$PATH"
    }
    
    stages{
        stage('Clone'){
            when {
                expression {
                    !skipRemainingStages
                }
            }
            steps{
                git url: 'https://github.com/mishra-priyanshu/hello-world.git', branch: 'master'
            }
        }
        stage('Build'){
            when {
                expression {
                    !skipRemainingStages
                }
            }
            steps{
                
                sh 'mvn clean package'
            }
        }
        stage("Copy to Docker Host"){
            when {
                expression {
                    !skipRemainingStages
                }
            }
            steps{
                sh 'sshpass -p dockeradmin scp  -o StrictHostKeyChecking=no  Dockerfile dockeradmin@172.31.3.204:/opt/docker-project'
                sh 'sshpass -p dockeradmin scp  -o StrictHostKeyChecking=no  webapp/target/*.war dockeradmin@172.31.3.204:/opt/docker-project'
            }
        }
        stage("Build Docker Image"){
            when {
                expression {
                    !skipRemainingStages
                }
            }
            steps{
                sh '''
                #!/bin/bash
                sshpass -p dockeradmin ssh  -o StrictHostKeyChecking=no  dockeradmin@172.31.3.204 << EOF
                #tag=$(cat /proc/sys/kernel/random/uuid)
                #echo $tag
                #echo $(hostname)
                cd /opt/docker-project 
                docker ps -aq | xargs docker stop | xargs docker rm;
                docker system prune  --force;
                docker image prune --force;
                docker build -t regapp:tag . ;
                exit 0;
                << EOF
                '''
            }
        }
        stage("Application Hosting"){
            when {
                expression {
                    !skipRemainingStages
                }
            }
            steps{
                sh '''
                #!/bin/bash
                sshpass -p dockeradmin ssh  -o StrictHostKeyChecking=no  dockeradmin@172.31.3.204 << EOF
                docker run -d  --name=registerapp-tag  -p  8082:8080  regapp:tag ;
                exit 0;
                << EOF
                '''
            }
        }
        stage("Application Status"){
            when {
                expression {
                    !skipRemainingStages
                }
            }
            steps{
                sh 'echo Application Successfully hosted'
            }
        }
        
    }
}
