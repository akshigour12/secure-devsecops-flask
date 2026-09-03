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

                        npm install -g snyk-to-html || true

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
                    trivy image \
                    --severity HIGH,CRITICAL \
                    --ignore-unfixed \
                    --format json \
                    -o trivy-report.json \
                    ${IMAGE_NAME}:${IMAGE_TAG}

                    trivy image \
                    --severity HIGH,CRITICAL \
                    --ignore-unfixed \
                    --format template \
                    --template "@contrib/html.tpl" \
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

            junit allowEmptyResults: true,
                  testResults: 'test-results.xml'

            archiveArtifacts artifacts: '''
                *.json,
                *.html,
                test-results.xml
            ''',
            allowEmptyArchive: true

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
                subject: "Build #${BUILD_NUMBER} - ${currentBuild.currentResult}",
                mimeType: 'text/html',
                to: 'YOUR_EMAIL@gmail.com',

                body: """
                <h2>Secure DevSecOps Pipeline</h2>

                <p><b>Build:</b> #${BUILD_NUMBER}</p>

                <p><b>Status:</b> ${currentBuild.currentResult}</p>

                <p><b>Project:</b> secure-devsecops-flask</p>

                <p>
                <a href="${BUILD_URL}">
                Open Jenkins Build
                </a>
                </p>

                <hr>

                <h3>Reports Attached</h3>

                <ul>
                  <li>JUnit Test Report</li>
                  <li>Semgrep Report</li>
                  <li>Snyk Report</li>
                  <li>Trivy Report</li>
                </ul>
                """,

                attachmentsPattern: '''
                    *.html,
                    *.json,
                    test-results.xml
                '''
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
