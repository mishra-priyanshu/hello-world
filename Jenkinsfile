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
                cd /opt/docker-project;
                docker build -t regapp:${BUILD_NUMBER} . ;
                '''
            }
        }
        stage("Application Hosting"){
            steps{
                sh '''
                #!/bin/bash
                sshpass -p dockeradmin ssh  -o StrictHostKeyChecking=no  dockeradmin@172.31.3.204;
                docker kill $(docker ps -q);
                docker run -d  --name=registerapp-${BUILD_NUMBER}  -p  8082:8080  regapp:${BUILD_NUMBER} ;
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
