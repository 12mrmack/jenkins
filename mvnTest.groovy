def call(){
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
}
