pipeline {
    agent any

    environment {
        DOCKER_DEV_REPO = "joshuarakesh/dev"   // Dev Docker Hub repo
        DOCKER_PROD_REPO = "joshuarakesh/prod" // Prod Docker Hub repo
        GIT_REPO = "https://github.com/joshuarakesh/Reactjs-E-commerce-App.git"
    }

    stages {
        stage('Clone Repository') {
            steps {
                script {
                    git branch: 'dev', credentialsId: 'github-token', url: env.GIT_REPO
                    env.BRANCH_NAME = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()

                    // Debugging: Print branch info
                    echo "Detected branch: ${env.BRANCH_NAME}"
                    echo "Jenkins branch: ${env.GIT_BRANCH}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    env.COMMIT_HASH = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    def IMAGE_TAG = "${env.DOCKER_DEV_REPO}:${env.COMMIT_HASH}"

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
            when { expression { env.BRANCH_NAME == 'dev' || env.GIT_BRANCH == 'origin/dev' } }
            steps {
                script {
                    sh "docker push ${env.DOCKER_DEV_REPO}:latest"
                    sh "docker push ${env.DOCKER_DEV_REPO}:${env.COMMIT_HASH}"
                }
            }
        }

        stage('Push to Docker Hub (Prod)') {
            when { expression { env.BRANCH_NAME == 'master' || env.GIT_BRANCH == 'origin/master' } }
            steps {
                script {
                    def IMAGE_TAG = "${env.DOCKER_PROD_REPO}:${env.COMMIT_HASH}"

                    sh "docker build -t ${IMAGE_TAG} ."
                    sh "docker tag ${IMAGE_TAG} ${env.DOCKER_PROD_REPO}:latest"
                    sh "docker push ${env.DOCKER_PROD_REPO}:${env.COMMIT_HASH}"
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
