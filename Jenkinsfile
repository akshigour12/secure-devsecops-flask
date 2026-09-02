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
                    pip install bandit safety semgrep
                '''
            }
        }

        stage('Unit Tests') {
            steps {
                sh '''
                    . venv/bin/activate
                    pytest -v
                '''
            }
        }

        stage('Bandit SAST') {
            steps {
                sh '''
                    . venv/bin/activate
                    bandit -r app.py -f json -o bandit-report.json || true
                '''
            }
        }

        stage('Snyk Dependency Scan') {
            steps {
                withCredentials([
                    string(credentialsId: 'snyk-token', variable: 'SNYK_TOKEN')
                ]) {
                    sh '''
                        snyk auth "$SNYK_TOKEN"
                        snyk test --file=requirements.txt --skip-unresolved
                    '''
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''
                        sonar-scanner
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

        stage('Trivy Scan') {
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
            archiveArtifacts artifacts: '''
                bandit-report.json,
                **/test-results.xml
            ''',
            allowEmptyArchive: true
        }
    }
}
