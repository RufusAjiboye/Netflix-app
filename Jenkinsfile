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
        
        stage('Sonarqube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Netflix \
                    -Dsonar.projectKey=Netflix '''
                }
            }
        }
        
        stage('Quality gate') {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'Sonar-token'
                }
            }
        }
        
        stage('Install Dependencies') {
            steps {
                sh "npm install"
            }
        }
        
        stage('OWASP FS Scan') {
            steps {
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        
        stage('TRIVY FS Scan') {
            steps {
                sh "trivy fs . > trivyfs.txt"
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