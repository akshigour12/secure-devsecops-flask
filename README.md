# 🔐 Secure DevSecOps CI/CD Pipeline for Flask Application

<p align="center">

![Python](https://img.shields.io/badge/Python-3.12-blue?logo=python)
![Flask](https://img.shields.io/badge/Flask-3.1-black?logo=flask)
![Jenkins](https://img.shields.io/badge/Jenkins-CI/CD-red?logo=jenkins)
![Docker](https://img.shields.io/badge/Docker-Container-blue?logo=docker)
![SonarQube](https://img.shields.io/badge/SonarQube-Code%20Quality-orange?logo=sonarqube)
![Semgrep](https://img.shields.io/badge/Semgrep-SAST-success)
![Snyk](https://img.shields.io/badge/Snyk-Dependency%20Security-purple?logo=snyk)
![Trivy](https://img.shields.io/badge/Trivy-Container%20Security-green)
![GitHub](https://img.shields.io/badge/GitHub-Security-black?logo=github)

</p>

---

# 📖 Overview

This project demonstrates the implementation of a **Secure DevSecOps CI/CD Pipeline** for a Flask web application using industry-standard DevOps and Security tools.

The primary objective of this project is to integrate **security into every stage of the Software Development Life Cycle (SDLC)** by automating testing, code quality analysis, security scanning, containerization, and deployment.

Unlike a traditional CI/CD pipeline, this project follows **DevSecOps principles** by incorporating multiple security controls from source code management to container image publishing.

---

# 🎯 Project Objectives

- Build a secure Flask web application
- Automate software delivery using Jenkins
- Implement Git security best practices
- Perform automated unit testing
- Integrate static code analysis
- Scan dependencies for known vulnerabilities
- Scan Docker images for security issues
- Publish Docker images automatically
- Generate security reports
- Send automated pipeline notifications

---

# ✨ Key Features

## 🔐 Git Security

- Feature Branch Workflow
- Branch Protection Rules
- CODEOWNERS Configuration
- Pull Request Based Development
- Pre-commit Hooks
- GitHub Webhook Integration

---

## ⚙️ CI/CD Automation

- Jenkins Declarative Pipeline
- Automatic Pipeline Trigger
- HTML Report Publishing
- Artifact Archiving
- Email Notifications

---

## 🛡 DevSecOps

- Pytest Unit Testing
- SonarQube Code Quality Analysis
- SonarQube Quality Gate
- Semgrep SAST
- Snyk Dependency Scan
- Trivy Container Security Scan

---

## 🐳 Containerization

- Dockerized Flask Application
- Python Slim Base Image
- Non-root Docker User
- Health Check
- Gunicorn Production Server
- Docker Hub Image Publishing

---

# 🛠 Tech Stack

| Category | Technology |
|------------|------------|
| Programming Language | Python 3.12 |
| Backend Framework | Flask |
| Version Control | Git |
| Repository Hosting | GitHub |
| CI/CD | Jenkins |
| Code Quality | SonarQube |
| Static Application Security Testing | Semgrep |
| Dependency Security | Snyk |
| Container Security | Trivy |
| Containerization | Docker |
| Container Registry | Docker Hub |
| Web Server | Gunicorn |
| Webhook Connectivity | Cloudflare Tunnel |

---

# 🏗 High-Level Architecture

```text
                    Developer
                         │
                         ▼
                GitHub Repository
                         │
       ┌────────────────────────────────┐
       │ Git Security Controls          │
       │ • Branch Protection            │
       │ • CODEOWNERS                   │
       │ • Pre-commit Hooks             │
       │ • Pull Requests                │
       └────────────────────────────────┘
                         │
                         ▼
                GitHub Webhook
                         │
                         ▼
               Cloudflare Tunnel
                         │
                         ▼
              Jenkins (Localhost)
                         │
         ┌───────────────┼────────────────┐
         │               │                │
         ▼               ▼                ▼
      Testing        Security        Container
```

---

# 🔐 Git Security Workflow

This project follows secure Git collaboration practices to protect the source code before it reaches the CI/CD pipeline.

```text
Developer

    │

Feature Branch

    │

Pre-commit Hooks

    │

Git Push

    │

Pull Request

    │

CODEOWNERS Review

    │

Branch Protection Validation

    │

Merge into main

    │

GitHub Webhook

    │

Cloudflare Tunnel

    │

Jenkins Pipeline Triggered
```

---

# 📂 Repository Structure

```text
secure-devsecops-flask/

├── app.py
├── Dockerfile
├── Jenkinsfile
├── docker-compose.yml
├── requirements.txt
├── sonar-project.properties
│
├── templates/
├── static/
├── tests/
│
├── README.md
└── LICENSE
```

---

# 🚀 Project Highlights

✔ Secure Git Workflow

✔ Automated CI/CD Pipeline

✔ Shift-Left Security

✔ Continuous Code Quality Analysis

✔ Automated Security Scanning

✔ Container Security Validation

✔ Automated Docker Image Publishing

✔ Production-ready Flask Deployment

# ⚙️ Jenkins CI/CD Pipeline

The project uses a **Jenkins Declarative Pipeline** to automate testing, security scanning, code quality validation, containerization, and deployment.

The pipeline is automatically triggered whenever changes are merged into the **main** branch.

---

## 🔄 Pipeline Workflow

```text
                GitHub Repository
                        │
                        ▼
             GitHub Webhook Trigger
                        │
                        ▼
             Cloudflare Tunnel
                        │
                        ▼
             Jenkins (Localhost)
                        │
        ┌───────────────┼────────────────┐
        │               │                │
        ▼               ▼                ▼
 Install Dependencies   Unit Testing   Security Analysis
        │
        ▼
 SonarQube Analysis
        │
        ▼
 Quality Gate
        │
        ▼
 Docker Image Build
        │
        ▼
 Trivy Image Scan
        │
        ▼
 Docker Hub Push
        │
        ▼
 Archive Reports
        │
        ▼
 Email Notification
```

---

# 📋 Jenkins Pipeline Stages

| Stage | Description |
|---------|-------------|
| Checkout | Downloads latest source code from GitHub |
| Install Dependencies | Creates Python virtual environment and installs project dependencies |
| Unit Tests | Executes automated tests using Pytest |
| Semgrep SAST | Performs Static Application Security Testing |
| Snyk Scan | Detects dependency vulnerabilities |
| SonarQube Analysis | Performs code quality analysis |
| Quality Gate | Validates SonarQube Quality Gate |
| Docker Build | Builds Docker image |
| Trivy Scan | Scans Docker image for HIGH & CRITICAL vulnerabilities |
| Docker Push | Publishes Docker image to Docker Hub |
| Post Actions | Archives reports and sends email notifications |

---

# 🔒 DevSecOps Security Workflow

The project follows a **Shift-Left Security** approach where security checks are integrated throughout the CI/CD pipeline.

```text
Developer
      │
      ▼
GitHub Push
      │
      ▼
Pre-commit Validation
      │
      ▼
Jenkins Trigger
      │
      ▼
Pytest
      │
      ▼
Semgrep
      │
      ▼
Snyk
      │
      ▼
SonarQube
      │
      ▼
Quality Gate
      │
      ▼
Docker Build
      │
      ▼
Trivy Scan
      │
      ▼
Docker Hub
```

---

# 🧪 Unit Testing

The project uses **Pytest** for automated unit testing.

### Objectives

- Validate application functionality
- Prevent regression issues
- Generate JUnit XML reports
- Execute automatically during every pipeline run

### Generated Report

- `test-results.xml`

---

# 🔍 Static Application Security Testing (Semgrep)

Semgrep scans the source code for insecure coding practices.

### Benefits

- Detect insecure coding patterns
- Identify security misconfigurations
- Generate JSON security reports
- Automated execution inside Jenkins

Generated Report

```
semgrep-report.json
```

---

# 📦 Dependency Security (Snyk)

Snyk scans Python dependencies for publicly disclosed vulnerabilities.

### Features

- Open Source Dependency Scan
- Known Vulnerability Detection
- JSON Report
- HTML Report

Generated Reports

```
snyk-report.json

snyk-report.html
```

---

# 📊 Code Quality (SonarQube)

SonarQube is integrated into the pipeline for continuous code quality analysis.

### Performs

- Static Code Analysis
- Code Smell Detection
- Bug Detection
- Maintainability Analysis
- Security Hotspots
- Quality Gate Validation

---

# 🛡 Container Security (Trivy)

Trivy performs vulnerability scanning on the generated Docker image.

### Scan Includes

- OS Packages
- Python Packages
- HIGH Vulnerabilities
- CRITICAL Vulnerabilities

Generated Reports

```
trivy-report.json

trivy-report.html
```

---

# 🐳 Docker Security

The Flask application is containerized following security best practices.

### Security Controls

- Python Slim Base Image
- Non-root User
- Health Check
- Gunicorn Production Server
- Updated System Packages

---

# ☁️ Cloudflare Tunnel Integration

Since Jenkins is hosted on **localhost**, GitHub cannot directly access it.

A **Cloudflare Tunnel** securely exposes Jenkins to receive GitHub webhook events without opening inbound ports.

Workflow:

```text
GitHub Push

      │

Webhook Event

      │

Cloudflare Tunnel

      │

Local Jenkins

      │

Pipeline Execution
```

---

# 📧 Automated Notifications

At the end of every pipeline execution Jenkins automatically:

- Archives generated reports
- Publishes HTML reports
- Sends build notification email
- Attaches security reports

Email includes:

- Build Number
- Build Status
- Docker Image
- Jenkins Build URL
- SonarQube Dashboard Link

---

# 📁 Generated Reports

| Report | Format |
|----------|--------|
| Pytest | XML |
| Semgrep | JSON |
| Snyk | JSON |
| Snyk | HTML |
| Trivy | JSON |
| Trivy | HTML |

---

# 🚀 Running the Project

## Clone Repository

```bash
git clone https://github.com/akshigour12/secure-devsecops-flask.git
```

Move into the project

```bash
cd secure-devsecops-flask
```

Install dependencies

```bash
pip install -r requirements.txt
```

Run the application

```bash
APP_USERNAME=<username> APP_PASSWORD=<password> python app.py 
```

---

# 🐳 Docker Deployment

Build Docker Image

```bash
docker build -t secure-devsecops-flask .
```

Run Container

```bash
docker run -e APP_USERNAME=<username> \
           -e APP_PASSWORD=<password> \
           -p 5000:5000 secure-devsecops-flask 
```

Access Application

```
http://localhost:5000
```

---
---

# 📊 Project Outcomes

The implementation of this project demonstrates how DevSecOps practices can be integrated into the software delivery lifecycle.

### Achievements

- ✔ Secure Git workflow using Branch Protection Rules and CODEOWNERS
- ✔ Automated CI/CD using Jenkins Declarative Pipeline
- ✔ Automated Unit Testing using Pytest
- ✔ Static Application Security Testing using Semgrep
- ✔ Dependency Vulnerability Scanning using Snyk
- ✔ Continuous Code Quality Analysis using SonarQube
- ✔ Docker Image Vulnerability Scanning using Trivy
- ✔ Automated Docker Image Publishing to Docker Hub
- ✔ Automated Email Notifications
- ✔ HTML & JSON Report Generation
- ✔ Secure Jenkins Trigger using Cloudflare Tunnel

---

# 📸 Project Screenshots

> **Note:** Add screenshots inside a `screenshots/` folder and update the paths below.

## Application

![Application](screenshots/application-home.png)

---

## GitHub Repository

![GitHub](screenshots/github-repository.png)

---

## Branch Protection Rules

![Branch Protection](screenshots/branch-protection.png)

---

## CODEOWNERS Configuration

![CODEOWNERS](screenshots/codeowners.png)

---

## Pull Request Workflow

![Pull Request](screenshots/pull-request.png)

---

## Jenkins Pipeline

![Jenkins](screenshots/jenkins-pipeline.png)

---

## SonarQube Dashboard

![SonarQube](screenshots/sonarqube-dashboard.png)

---

## Semgrep Report

![Semgrep](screenshots/semgrep-report.png)

---

## Snyk Report

![Snyk](screenshots/snyk-report.png)

---

## Trivy Report

![Trivy](screenshots/trivy-report.png)

---

## Docker Hub Repository

![DockerHub](screenshots/dockerhub.png)

---

# 📁 Reports Generated

During every pipeline execution the following reports are automatically generated and archived.

| Report | Format |
|---------|--------|
| Pytest | XML |
| Semgrep | JSON |
| Snyk | JSON |
| Snyk | HTML |
| Trivy | JSON |
| Trivy | HTML |

---

# 🔐 Security Controls Implemented

## Git Security

- Feature Branch Workflow
- Branch Protection Rules
- CODEOWNERS
- Pull Request Approval
- Pre-commit Hooks
- GitHub Webhooks

---

## CI/CD Security

- Automated Pipeline
- Quality Gate Validation
- Automated Security Scans
- Report Archiving
- Email Notifications

---

## Container Security

- Non-root User
- Python Slim Image
- Docker Health Check
- Gunicorn Production Server

---

# 🚀 Future Enhancements

Future improvements planned for this project include:

- Kubernetes Deployment
- GitHub Actions CI/CD Pipeline
- OWASP ZAP DAST Integration
- Prometheus Monitoring
- Grafana Dashboard
- Terraform Infrastructure as Code
- AWS ECS/EKS Deployment
- Secrets Management using HashiCorp Vault
- Automated Version Tagging
- Slack / Microsoft Teams Notifications

---

# ⚠ Known Limitations

- Trivy currently reports container package vulnerabilities that require further investigation.
- Some Semgrep findings are informational and related to development configuration.
- The current deployment is intended for demonstration and learning purposes.

---

# 💼 Resume Highlights

This project demonstrates practical experience with:

- DevSecOps
- Continuous Integration & Continuous Delivery
- Secure SDLC
- Docker Containerization
- Git Security
- Static Application Security Testing
- Dependency Security
- Container Security
- Jenkins Automation
- Code Quality Analysis

---

# 🎯 Skills Demonstrated

- Python
- Flask
- Git
- GitHub
- Jenkins
- Docker
- SonarQube
- Semgrep
- Snyk
- Trivy
- Cloudflare Tunnel
- Gunicorn
- Linux
- Shell Scripting

---

# 🤝 Contribution

Contributions, suggestions, and improvements are welcome.

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Open a Pull Request

---

# 📄 License

This project is licensed under the **MIT License**.

---

# 👩‍💻 Author

**Akshita Gour**

**GitHub:** https://github.com/akshigour12

**LinkedIn:** https://www.linkedin.com/in/<your-linkedin-username>

---

## ⭐ Support

If you found this project useful, consider giving it a **Star ⭐** on GitHub.

If you have any suggestions or feedback, feel free to open an Issue or Pull Request.

---

<p align="center">

### 🔐 Secure Code • 🚀 Automated Delivery • 🛡 Security First

**Built with ❤️ using Flask, Jenkins, Docker & DevSecOps Practices**

</p>
