pipeline {
    agent any

    environment {
        IMAGE_NAME = "omareltabakh/devops-static-site"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/OmarEltabakh123/jenkins-to-argocd-pipeline-.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Scan with Trivy') {
            steps {
                sh 'trivy image --exit-code 1 --severity HIGH $IMAGE_NAME || true'
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh '''
                        echo "$PASS" | docker login -u "$USER" --password-stdin
                        docker push $IMAGE_NAME
                    '''
                }
            }
        }
    }
}
