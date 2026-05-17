def call(string branch,string gitUrl){
	stage('Checkout Code') {
            steps {
                checkout scmGit(
                    branches: [[name: '${branch}']],
                    extensions: [],
                    userRemoteConfigs: [[
                        url: ${gitUrl}
                    ]]
                )
                echo 'Repository Checkout Successful'
            }
        }
}
