pipeline {
    agent any

    tools {
        dependencyCheck 'DependencyCheck'
    }

    environment {
        IMAGE_NAME = "akshigour12/secure-devsecops-flask"
        IMAGE_TAG = "latest"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Setup Python') {
            steps {
                sh '''
                python3 -m venv venv
                . venv/bin/activate
                pip install --upgrade pip
                pip install -r requirements.txt
                pip install bandit safety semgrep pytest
                '''
            }
        }

        stage('Unit Tests') {
            steps {
                sh '''
                . venv/bin/activate
                pytest
                '''
            }
        }

        stage('Bandit Scan') {
            steps {
                sh '''
                . venv/bin/activate
                bandit -r .
                '''
            }
        }

        stage('Safety Scan') {
            steps {
                sh '''
                . venv/bin/activate
                safety scan || true
                '''
            }
        }

        stage('Semgrep Scan') {
            steps {
                withCredentials([string(credentialsId: 'SEMGREP_APP_Token', variable: 'SEMGREP_APP_TOKEN')]) {
                    sh '''
                    . venv/bin/activate
                    semgrep ci || true
                    '''
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''
                    SonarScanner/bin/sonar-scanner \
                    -Dsonar.projectKey=secure-devsecops-flask \
                    -Dsonar.sources=. \
                    -Dsonar.python.version=3.12
                    '''
                }
            }
        }

        stage('OWASP Dependency Check') {
            steps {
                dependencyCheck additionalArguments: '--scan .', odcInstallation: 'DependencyCheck'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }

        stage('Snyk Scan') {
            steps {
                withCredentials([string(credentialsId: 'snyk-token', variable: 'SNYK_TOKEN')]) {
                    sh '''
                    snyk auth $SNYK_TOKEN
                    snyk test --file=requirements.txt --skip-unresolved
                    '''
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                docker build -t $IMAGE_NAME:$IMAGE_TAG .
                '''
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub',
                                                 usernameVariable: 'DOCKER_USER',
                                                 passwordVariable: 'DOCKER_PASS')]) {

                    sh '''
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    docker push $IMAGE_NAME:$IMAGE_TAG
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                docker rm -f secure-devsecops-flask || true

                docker run -d \
                --name secure-devsecops-flask \
                -p 5000:5000 \
                -e APP_USERNAME=admin \
                -e APP_PASSWORD=admin123 \
                $IMAGE_NAME:$IMAGE_TAG
                '''
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
