# 🔐 Secure DevSecOps Flask Application

> A production-inspired Secure DevSecOps CI/CD Pipeline built using Flask, Jenkins, Docker, SonarQube, Snyk, Semgrep, Trivy and Docker Hub.

![Python](https://img.shields.io/badge/Python-3.12-blue)
![Flask](https://img.shields.io/badge/Flask-3.1-black)
![Docker](https://img.shields.io/badge/Docker-Containerized-blue)
![Jenkins](https://img.shields.io/badge/Jenkins-CI%2FCD-red)
![SonarQube](https://img.shields.io/badge/SonarQube-Code%20Quality-orange)
![Snyk](https://img.shields.io/badge/Snyk-Security-purple)
![Trivy](https://img.shields.io/badge/Trivy-Container%20Security-green)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

---

# 📌 Project Overview

This project demonstrates a **Secure DevSecOps CI/CD Pipeline** for a Flask web application.

The pipeline automates:

- Source Code Checkout
- Dependency Installation
- Unit Testing
- Static Application Security Testing (SAST)
- Dependency Vulnerability Scanning
- Code Quality Analysis
- Docker Image Build
- Container Image Security Scanning
- Docker Image Publishing

The goal is to integrate security at every stage of the Software Development Lifecycle (SDLC).

---

# 🚀 Features

- Flask Web Application
- Dockerized Deployment
- Jenkins Declarative Pipeline
- Automated Unit Testing using Pytest
- Static Code Analysis using SonarQube
- SAST using Semgrep
- Dependency Security using Snyk
- Container Vulnerability Scanning using Trivy
- HTML & JSON Security Reports
- Email Notifications after Pipeline Execution
- Non-root Docker Container
- Production-ready deployment using Gunicorn

---

# 🏗 Architecture

```
                GitHub Repository
                       │
                       ▼
                  Jenkins Pipeline
                       │
     ┌─────────────────┼─────────────────┐
     │                 │                 │
     ▼                 ▼                 ▼
  Pytest          SonarQube          Semgrep
     │                 │                 │
     └─────────────────┼─────────────────┘
                       ▼
                     Snyk
                       │
                       ▼
                 Docker Build
                       │
                       ▼
                  Trivy Scan
                       │
                       ▼
                 Docker Hub Push
```

---

# ⚙️ Tech Stack

| Category | Technology |
|----------|------------|
| Backend | Flask |
| Language | Python |
| Testing | Pytest |
| CI/CD | Jenkins |
| Code Quality | SonarQube |
| SAST | Semgrep |
| Dependency Scan | Snyk |
| Container Security | Trivy |
| Containerization | Docker |
| Deployment | Gunicorn |

---

# 📂 Project Structure

```
secure-devsecops-flask/

├── app.py
├── requirements.txt
├── Dockerfile
├── docker-compose.yml
├── Jenkinsfile
├── sonar-project.properties
│
├── templates/
├── static/
├── tests/
│
├── screenshots/
│
└── README.md
```

---

# 🔄 Jenkins CI/CD Pipeline

The Jenkins pipeline executes the following stages automatically:

```
Checkout

↓

Install Dependencies

↓

Unit Testing (Pytest)

↓

Semgrep SAST

↓

Snyk Dependency Scan

↓

SonarQube Analysis

↓

Quality Gate

↓

Docker Build

↓

Trivy Image Scan

↓

Docker Push
```

---

# 🔒 Security Integration

## ✅ Pytest

- Automated unit testing
- XML report generation
- Executed during every pipeline run

---

## ✅ SonarQube

- Code Quality Analysis
- Code Smells Detection
- Maintainability Analysis
- Quality Gate Validation

---

## ✅ Semgrep

- Static Application Security Testing
- Detects insecure coding patterns
- JSON report generation

---

## ✅ Snyk

- Dependency Vulnerability Analysis
- Open Source Security Scan
- HTML & JSON Reports

---

## ✅ Trivy

- Docker Image Vulnerability Scan
- HIGH & CRITICAL Severity Detection
- HTML & JSON Reports

---

# 🐳 Docker

The application is containerized using Docker.

Security enhancements include:

- Python Slim Base Image
- Non-root User
- Updated Packages
- Health Check
- Gunicorn Production Server

---

# ▶️ Running Locally

## Clone Repository

```bash
git clone https://github.com/akshigour12/secure-devsecops-flask.git
```

```
cd secure-devsecops-flask
```

Install dependencies

```bash
pip install -r requirements.txt
```

Run Flask

```bash
python app.py
```

---

# 🐳 Run with Docker

Build Image

```bash
docker build -t secure-devsecops-flask .
```

Run Container

```bash
docker run -p 5000:5000 secure-devsecops-flask
```

---

# 📸 Screenshots

Add screenshots here:

- Application UI
- Jenkins Pipeline
- SonarQube Dashboard
- Snyk Report
- Trivy Report
- Semgrep Report
- Docker Hub Repository

---

# 📈 Pipeline Reports

The pipeline automatically generates:

- JUnit XML Report
- Semgrep JSON Report
- Snyk JSON Report
- Snyk HTML Report
- Trivy JSON Report
- Trivy HTML Report

Reports are archived in Jenkins after every successful build.

---

# 🚀 Future Improvements

- Kubernetes Deployment
- GitHub Actions Pipeline
- Terraform Infrastructure
- OWASP ZAP DAST Integration
- Prometheus Monitoring
- Grafana Dashboard
- Automated Deployment to Cloud

---

# ⚠️ Known Issue

The current Trivy scan reports HIGH vulnerabilities related to Python packages inside the container image. The application upgrades core Python packaging tools during the Docker build, while dependency scanning reports no known vulnerabilities. This difference is documented for future investigation and improvement.

---

# 👩‍💻 Author

**Akshita Gour**

GitHub: https://github.com/akshigour12

LinkedIn: https://www.linkedin.com/in/akshita-g-6a24871a4/

---

# ⭐ Support

If you found this project useful, consider giving it a ⭐ on GitHub.
