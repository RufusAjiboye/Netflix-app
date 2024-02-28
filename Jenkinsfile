pipeline {
    agent any
    tools{
        jdk 'jdk17'
        nodejs 'node16'
    }
    
    environment {
        SCANNER_HOME=tool 'sonar-scanner'
    }
    
    stages {
        stage('clean workspace') {
            steps{
                cleanWs()
            }
        }
        
        stage('Checkout from Git') {
            steps{
                git branch: 'main', url: 'https://github.com/SoftwareDevDeveloper/Netflix-app'
            
            }
        }

        // Scan the code for issues and bugs
        stage('Sonarqube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Netflix \
                    -Dsonar.projectKey=Netflix '''
                }
            }
        }

         // Check for security issues in the code
        stage('Quality gate') {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'Sonar-scanner'
                }
            }
        }
        
        stage('Install Dependencies') {
            steps {
                sh "npm install"
            }
        }
        
        // Chekc for security of the web application
        stage('OWASP FS Scan') {
            steps {
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        
        stage('Build the docker image') {
            steps  {
                script{
                   withDockerRegistry(credentialsId: 'docker', toolName: 'docker'){
                      sh '''
                      sudo docker build --build-arg TMDB_V3_API_KEY=56873956ae9f2853376e3ce3c907bfbf -t netflix .
                      sudo docker tag netflix 02271589/netflix:latest
                      sudo docker push 02271589/netflix:latest
                   '''
                   }
                }
            }
        }

        stage('Run docker Image') {
            steps {
                sh "docker run --name myapp -d -p 8080:80 02271589/netflixapplication:latest"
            }
        }

        // stage('Run docker image') {
        //     steps  { 
        //         sh 'docker run -d -p 80:5000 02271589/proj:$version'
        //     }
        // }

        // stage ('login to the image repo') {
        //     steps {
        //         echo "login to docker hub repo"
        //           sh 'docker login -u $hub_username -p $hub_password'
        //     }
        // }
        
         
        stage('TRIVY FS Scan') {
            steps {
                sh "trivy fs . > trivyfs.txt"
            }
        }

        stage('Deploy to kubernets'){
            steps{
                script{
                    dir('Kubernetes') {
                        withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'k8s', namespace: '', restrictKubeConfigAccess: false, serverUrl: '') {
                                sh 'kubectl apply -f deployment.yml'
                                sh 'kubectl apply -f service.yml'
                        }
                    }
                }
            }
        }
    }
        
    post {
        always {
            emailext attachLog: true,
                subject: "'${currentBuild.result}'",
                body: "Project: ${env.JOB_NAME}<br/>" +
                  "Build Number: ${env.BUILD_NUMBER}<br/>" +
                  "URL: ${env.BUILD_URL}<br/>",
                to: 'ruufman@gmail.com',
                attachmentsPattern: 'trivyfs.txt,trivyimage.txt'
        }
    }
}