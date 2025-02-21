pipeline {
    agent any

    environment {
        DOCKER_DEV_REPO = "joshuarakesh/dev"   // Dev Docker Hub repo
        DOCKER_PROD_REPO = "joshuarakesh/prod" // Prod Docker Hub repo
        GIT_REPO = "https://github.com/joshuarakesh/Reactjs-E-commerce-App.git"
        BRANCH_NAME = "dev"  // Default branch (this should be set dynamically)
    }

    stages {
        stage('Clone Repository') {
            steps {
                script {
                    checkout scm
                    BRANCH_NAME = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    COMMIT_HASH = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    IMAGE_TAG = "${env.DOCKER_DEV_REPO}:${COMMIT_HASH}"

                    sh "docker build -t ${IMAGE_TAG} ."
                    sh "docker tag ${IMAGE_TAG} ${env.DOCKER_DEV_REPO}:latest"
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Push to Docker Hub (Dev)') {
            when { expression { env.BRANCH_NAME == 'dev' } }
            steps {
                script {
                    sh "docker push ${env.DOCKER_DEV_REPO}:latest"
                    sh "docker push ${env.DOCKER_DEV_REPO}:${COMMIT_HASH}"
                }
            }
        }

        stage('Push to Docker Hub (Prod)') {
            when { expression { env.BRANCH_NAME == 'master' } }
            steps {
                script {
                    COMMIT_HASH = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    IMAGE_TAG = "${env.DOCKER_PROD_REPO}:${COMMIT_HASH}"

                    sh "docker build -t ${IMAGE_TAG} ."
                    sh "docker tag ${IMAGE_TAG} ${env.DOCKER_PROD_REPO}:latest"
                    sh "docker push ${env.DOCKER_PROD_REPO}:${COMMIT_HASH}"
                    sh "docker push ${env.DOCKER_PROD_REPO}:latest"
                }
            }
        }
    }

    post {
        always {
            sh 'docker logout'
            sh 'docker image prune -f' // Cleanup old images
        }
    }
}
