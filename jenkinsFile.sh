pipeline {
    agent any

    tools {
        maven 'maven'
    }
    
    parameters {
        choice(
            name: 'CHOICE',
            choices: ['dev', 'test', 'production'],
            description: 'Select deployment environment'
        )
    }
    

    stages {

        stage('Checkout Code') {
            steps {
                checkout scmGit(
                    branches: [[name: '*/master']],
                    extensions: [],
                    userRemoteConfigs: [[
                        url: 'https://github.com/opstree/spring3hibernate.git'
                    ]]
                )
                echo 'Repository Checkout Successful'
            }
        }

        stage('GitLeaks Scan') {
            steps {
                sh '''
                /usr/local/bin/gitleaks detect \
                --source . \
                --report-format json \
                --report-path gitleaks-report.json || true
                '''
            }
        }
        
        stage('Print GitLeaks Report') {
            steps {
                sh 'cat gitleaks-report.json || true'
            }
        }

        stage('Maven Compile') {
            steps {
                sh "mvn clean compile"
            }
        }

        stage('Maven Test') {
            steps {
                sh "mvn test"
            }
        }

        stage('Ask Before Build') {
            steps {
                input(
                    message: "Should we continue?",
                    ok: "Yes, continue",
                    parameters: [
                        string(
                            name: 'PERSON',
                            defaultValue: 'Mr Jenkins',
                            description: 'Who should I say hello to?'
                        )
                    ]
                )
            }
        }

        stage('Maven Package') {
            when { environment name: 'CHOICE', value: 'test' }
            steps {
                sh "mvn package -DskipTests"
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'gitleaks-report.json', fingerprint: true
            echo 'GitLeaks report archived successfully'
        }

        success {
            echo 'Pipeline completed successfully'
        }

        failure {
            echo 'Pipeline failed'
        }
    }
}
