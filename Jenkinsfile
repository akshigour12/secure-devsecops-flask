pipeline {
    agent any

    environment {
        IMAGE_NAME = "akshigour12/secure-devsecops-flask"
        IMAGE_TAG  = "latest"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate

                    python -m pip install --upgrade pip
                    pip install -r requirements.txt
                    pip install semgrep
                '''
            }
        }

        stage('Unit Tests') {
            steps {
                sh '''
                    . venv/bin/activate

                    pytest -v \
                        --junitxml=test-results.xml || true
                '''
            }
        }

        stage('Semgrep SAST') {
            steps {
                withCredentials([
                    string(credentialsId: 'SEMGREP_APP_Token', variable: 'SEMGREP_APP_TOKEN')
                ]) {
                    sh '''
                        . venv/bin/activate

                        export SEMGREP_APP_TOKEN=$SEMGREP_APP_TOKEN

                        semgrep login || true

                        semgrep scan \
                            --config auto \
                            --json \
                            --output semgrep-report.json || true
                    '''
                }
            }
        }

        stage('Snyk Dependency Scan') {
            steps {
                withCredentials([
                    string(credentialsId: 'snyk-token', variable: 'SNYK_TOKEN')
                ]) {
                    sh '''
                        . venv/bin/activate

                        snyk auth $SNYK_TOKEN

                        snyk test \
                            --command=python3 \
                            --json-file-output=snyk-report.json || true

                        snyk-to-html \
                            -i snyk-report.json \
                            -o snyk-report.html || true
                    '''
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''
                        /var/lib/jenkins/tools/hudson.plugins.sonar.SonarRunnerInstallation/SonarScanner/bin/sonar-scanner
                    '''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: false
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    docker build \
                        -t ${IMAGE_NAME}:${IMAGE_TAG} .
                '''
            }
        }

       stage('Trivy Image Scan') {
    steps {
        sh '''
            /usr/local/bin/trivy --config /dev/null image \
                --severity HIGH,CRITICAL \
                --ignore-unfixed \
                --format json \
                -o trivy-report.json \
                ${IMAGE_NAME}:${IMAGE_TAG}

            /usr/local/bin/trivy --config /dev/null image \
                --severity HIGH,CRITICAL \
                --ignore-unfixed \
                --format template \
                --template "@/usr/local/share/trivy/templates/html.tpl" \
                -o trivy-report.html \
                ${IMAGE_NAME}:${IMAGE_TAG} || true
        '''
    }
}

        stage('Docker Push') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login \
                            -u "$DOCKER_USER" \
                            --password-stdin

                        docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        }
    }

    post {

        always {

            junit(
                allowEmptyResults: true,
                testResults: 'test-results.xml'
            )

            archiveArtifacts(
                artifacts: '*.json,*.html,test-results.xml',
                allowEmptyArchive: true
            )

            publishHTML(target: [
                allowMissing: true,
                alwaysLinkToLastBuild: true,
                keepAll: true,
                reportDir: '.',
                reportFiles: 'trivy-report.html',
                reportName: 'Trivy Security Report'
            ])

            publishHTML(target: [
                allowMissing: true,
                alwaysLinkToLastBuild: true,
                keepAll: true,
                reportDir: '.',
                reportFiles: 'snyk-report.html',
                reportName: 'Snyk Dependency Report'
            ])

            emailext(

                subject: "Jenkins Build #${BUILD_NUMBER} - ${currentBuild.currentResult}",

                to: "akshigour12@gmail.com",

                mimeType: 'text/html',

                body: """
                <html>

                <body style="font-family:Arial">

                <h2>Secure DevSecOps Pipeline Report</h2>

                <table border="1" cellpadding="8">

                    <tr>
                        <td><b>Project</b></td>
                        <td>secure-devsecops-flask</td>
                    </tr>

                    <tr>
                        <td><b>Build</b></td>
                        <td>#${BUILD_NUMBER}</td>
                    </tr>

                    <tr>
                        <td><b>Status</b></td>
                        <td>${currentBuild.currentResult}</td>
                    </tr>

                    <tr>
                        <td><b>Docker Image</b></td>
                        <td>${IMAGE_NAME}:${IMAGE_TAG}</td>
                    </tr>

                </table>

                <br>

                <h3>Pipeline Stages</h3>

                <ul>
                    <li>Source Checkout</li>
                    <li>Unit Testing (Pytest)</li>
                    <li>Semgrep SAST</li>
                    <li>Snyk Dependency Scan</li>
                    <li>SonarQube Analysis</li>
                    <li>Quality Gate</li>
                    <li>Docker Build</li>
                    <li>Trivy Image Scan</li>
                    <li>Docker Push</li>
                </ul>

                <h3>Reports Attached</h3>

                <ul>
                    <li>JUnit Test Report</li>
                    <li>Semgrep JSON Report</li>
                    <li>Snyk JSON Report</li>
                    <li>Snyk HTML Report</li>
                    <li>Trivy JSON Report</li>
                    <li>Trivy HTML Report</li>
                </ul>

                <br>

                <p>
                    <b>Jenkins Build:</b><br>
                    <a href="${BUILD_URL}">
                    ${BUILD_URL}
                    </a>
                </p>

                <p>
                    <b>SonarQube Dashboard:</b><br>
                    <a href="http://localhost:9000/dashboard?id=secure-devsecops-flask">
                    http://localhost:9000/dashboard?id=secure-devsecops-flask
                    </a>
                </p>

                </body>

                </html>
                """,

                attachmentsPattern: "*.json,*.html,test-results.xml"
            )

            cleanWs()
        }

        success {
            echo "Pipeline completed successfully."
        }

        failure {
            echo "Pipeline failed."
        }
    }
}
