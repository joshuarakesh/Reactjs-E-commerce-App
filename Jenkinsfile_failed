pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub')  // Use stored Docker credentials
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
                sh 'docker build -t $DOCKER_DEV_REPO:latest .'
            }
        }

        stage('Push to Docker Hub (Dev)') {
            when {
                branch 'dev'
            }
            steps {
                sh 'echo $DOCKER_HUB_CREDENTIALS | docker login -u joshuarakesh --password-stdin'
                sh 'docker push $DOCKER_DEV_REPO:latest'
            }
        }

        stage('Push to Docker Hub (Prod)') {
            when {
                branch 'master'
            }
            steps {
                sh 'echo $DOCKER_HUB_CREDENTIALS | docker login -u joshuarakesh --password-stdin'
                sh 'docker build -t $DOCKER_PROD_REPO:latest .'
                sh 'docker push $DOCKER_PROD_REPO:latest'
            }
        }
    }
}
