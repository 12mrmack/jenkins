def call(string report_file_name){
	stage('GitLeaks Scan') {
                sh '''
                /usr/local/bin/gitleaks detect \
                --source . \
                --report-format json \
                --report-path ${report_file_name} || true
                '''
            }
        
        stage('Print GitLeaks Report') {
                sh 'cat ${report_file_name} || true'
        }
}
