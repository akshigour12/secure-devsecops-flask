pipeline {
    agent any

    environment {
        IMAGE_NAME = "akshigour12/secure-devsecops-flask"
        IMAGE_TAG  = "latest"
        SCANNER_HOME = tool 'SonarScanner'
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

        stage('Workspace Debug') {
            steps {
                sh '''
                    echo "===== Current Directory ====="
                    pwd

                    echo "===== Repository Files ====="
                    ls -R
                '''
            }
        }

        stage('Unit Tests') {
            steps {
                sh '''
                    . venv/bin/activate

                    if [ -d tests ]; then
                        pytest -v tests
                    else
                        echo "No tests directory found."
                    fi
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
                          --file=requirements.txt \
                          --skip-unresolved
                    '''
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''
                        . venv/bin/activate

                        ${SCANNER_HOME}/bin/sonar-scanner
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
                    trivy image \
                      --severity HIGH,CRITICAL \
                      --exit-code 1 \
                      ${IMAGE_NAME}:${IMAGE_TAG}
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
            archiveArtifacts artifacts: '*.json', allowEmptyArchive: true
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
