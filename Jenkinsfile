
pipeline {
    agent any    
    environment {
        DOCKER_IMAGE = "shashi40410/telecom-churn-prediction"
    }
    stages {
        stage('Cleanup Workspace') {
            agent { label 'MySlave1' }
            steps {
                cleanWs()
            }
        }
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/sbrao-learning/telecom-churn-prediction.git'
            }
        }
        stage('Build Docker Image') {
            agent { label 'MySlave1' }
            steps {
                script {
                    sh 'docker build -t $DOCKER_IMAGE .'
                }
            }
        }
        stage('Push to DockerHub') {
            agent { label 'MySlave1' }
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker push $DOCKER_IMAGE'
                }
            }
        }
    }
}
