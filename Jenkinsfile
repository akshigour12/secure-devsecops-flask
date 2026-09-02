pipeline {
    agent any

    environment {
        IMAGE_NAME = "akshigour12/secure-devsecops-flask"
        IMAGE_TAG = "latest"

        SEMGREP_REPORT = "semgrep-report.json"
        SNYK_REPORT = "snyk-report.json"
        TRIVY_REPORT = "trivy-report.json"
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
                    pip install pytest semgrep
                '''
            }
        }

        stage('Unit Tests') {
            steps {
                sh '''
                    . venv/bin/activate

                    pytest \
                      --junitxml=test-results.xml || true
                '''
            }
        }

        stage('Semgrep SAST') {
            steps {
                withCredentials([
                    string(credentialsId: 'SEMGREP_APP_Token',
                    variable: 'SEMGREP_APP_TOKEN')
                ]) {
                    sh '''
                        . venv/bin/activate

                        export SEMGREP_APP_TOKEN=$SEMGREP_APP_TOKEN

                        semgrep login || true

                        semgrep scan \
                            --config auto \
                            --json \
                            --output $SEMGREP_REPORT || true
                    '''
                }
            }
        }

        stage('Snyk Dependency Scan') {
            steps {
                withCredentials([
                    string(credentialsId: 'snyk-token',
                    variable: 'SNYK_TOKEN')
                ]) {
                    sh '''
                        /usr/local/bin/snyk auth $SNYK_TOKEN || true

                        /usr/local/bin/snyk test \
                            --file=requirements.txt \
                            --json > $SNYK_REPORT || true
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
                    /usr/local/bin/trivy image \
                        --format json \
                        --output $TRIVY_REPORT \
                        --severity HIGH,CRITICAL \
                        --exit-code 0 \
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

        stage('Verify Reports') {
            steps {
                sh '''
                    echo "===== Generated Reports ====="

                    ls -lh

                    echo

                    [ -f test-results.xml ] && echo "✓ test-results.xml"
                    [ -f semgrep-report.json ] && echo "✓ semgrep-report.json"
                    [ -f snyk-report.json ] && echo "✓ snyk-report.json"
                    [ -f trivy-report.json ] && echo "✓ trivy-report.json"
                '''
            }
        }
    }

    post {

        always {

            junit allowEmptyResults: true,
                  testResults: 'test-results.xml'

            archiveArtifacts artifacts: '''
test-results.xml,
semgrep-report.json,
snyk-report.json,
trivy-report.json
''',
            allowEmptyArchive: true

            cleanWs()
        }

        success {
            echo 'Pipeline completed successfully.'
        }

        failure {
            echo 'Pipeline failed.'
        }
    }
}
