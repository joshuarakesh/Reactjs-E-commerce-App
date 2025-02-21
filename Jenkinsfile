pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub')  // Ensure this exists in Jenkins credentials
        DOCKER_DEV_REPO = "joshuarakesh/dev"   // Your dev Docker Hub repo
        DOCKER_PROD_REPO = "joshuarakesh/prod" // Your prod Docker Hub repo
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'dev', credentialsId: 'github-token', url: 'https://github.com/joshuarakesh/Reactjs-E-commerce-App.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${env.DOCKER_DEV_REPO}:latest .'
            }
        }

        stage('Login to Docker Hub') {
            steps {
                sh 'echo ${env.DOCKER_HUB_CREDENTIALS_PSW} | docker login -u ${env.DOCKER_HUB_CREDENTIALS_USR} --password-stdin'
            }
        }

        stage('Push to Docker Hub (Dev)') {
            when {
                branch 'dev'
            }
            steps {
                sh 'docker push ${env.DOCKER_DEV_REPO}:latest'
            }
        }

        stage('Push to Docker Hub (Prod)') {
            when {
                branch 'master'
            }
            steps {
                sh 'docker build -t ${env.DOCKER_PROD_REPO}:latest .'
                sh 'docker push ${env.DOCKER_PROD_REPO}:latest'
            }
        }
    }

    post {
        always {
            sh 'docker logout'
        }
    }
}
