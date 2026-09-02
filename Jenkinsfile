pipeline {
    agent any

    environment {
        IMAGE_NAME = "akshigour12/secure-devsecops-flask"
        IMAGE_TAG = "latest"

        TRIVY_REPORT = "trivy-report.json"
        SNYK_REPORT = "snyk-report.json"

        SONAR_SCANNER = "/var/lib/jenkins/tools/hudson.plugins.sonar.SonarRunnerInstallation/SonarScanner/bin/sonar-scanner"
        SNYK = "/usr/local/bin/snyk"
        TRIVY = "/usr/local/bin/trivy"
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

                    export PYTHONPATH=$WORKSPACE

                    echo "Current directory:"
                    pwd

                    ls -la

                    python -c "import app; print('Flask app import successful')"

                    pytest tests \
                        -v \
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

                        semgrep scan \
                            --config auto \
                            --json \
                            --output semgrep-report.json || true

                        ls -l semgrep-report.json || true
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
                        $SNYK auth $SNYK_TOKEN || true

                        $SNYK test \
                            --file=requirements.txt \
                            --json-file-output=$SNYK_REPORT || true

                        ls -l $SNYK_REPORT || true
                    '''
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''
                        $SONAR_SCANNER || true
                    '''
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                '''
            }
        }

        stage('Trivy Image Scan') {
            steps {
                sh '''
                    $TRIVY image \
                        --format json \
                        --output $TRIVY_REPORT \
                        --severity HIGH,CRITICAL \
                        --exit-code 0 \
                        ${IMAGE_NAME}:${IMAGE_TAG} || true

                    ls -l $TRIVY_REPORT || true
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
            echo "========= REPORTS ========="
            ls -lh
            echo

            test -f semgrep-report.json && echo "Semgrep OK"
            test -f snyk-report.json && echo "Snyk OK"
            test -f trivy-report.json && echo "Trivy OK"
            test -f test-results.xml && echo "JUnit OK"
        '''
    }
}
    
    }

    
    

    post {
        always {

            junit allowEmptyResults: true,
                  testResults: 'test-results.xml'

            archiveArtifacts(
                artifacts: 'test-results.xml,semgrep-report.json,snyk-report.json,trivy-report.json',
                allowEmptyArchive: true
            )

            cleanWs()
        }

        success {
            echo 'Pipeline completed successfully.'
        }

        unstable {
            echo 'Pipeline completed with warnings.'
        }

        failure {
            echo 'Pipeline failed.'
        }
    }
}
