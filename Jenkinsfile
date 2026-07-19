pipeline {
    agent none

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
        DOCKERHUB_USERNAME    = "purushothdoc"
        IMAGE_NAME            = "webapp"
        IMAGE_TAG             = "${env.BUILD_NUMBER}"
        FULL_IMAGE            = "${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"
    }

    stages {

        stage('Checkout') {
            agent any
            steps {
                checkout scm
                stash name: 'source', includes: '**'
            }
        }

        stage('Build & Push Image') {
            agent { label 'built-in' }   // Jenkins controller node, has Docker installed
            steps {
                unstash 'source'
                sh '''
                    echo "$DOCKERHUB_CREDENTIALS_PSW" | docker login -u "$DOCKERHUB_CREDENTIALS_USR" --password-stdin
                    docker build -t $FULL_IMAGE -t $DOCKERHUB_USERNAME/$IMAGE_NAME:latest .
                    docker push $FULL_IMAGE
                    docker push $DOCKERHUB_USERNAME/$IMAGE_NAME:latest
                    docker logout
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            agent { label 'k8s-master' }   // Kubernetes master node, registered as Jenkins agent, has kubectl configured
            steps {
                unstash 'source'
                sh '''
                    sed -i "s#purushothdoc/webapp:latest#$FULL_IMAGE#g" Deployment.yaml

                    kubectl apply -f Deployment.yaml
                    kubectl apply -f Service.yaml

                    kubectl rollout status deployment/webapp-deployment --timeout=120s
                '''
            }
        }
    }

    post {
        success {
            echo "Deployed ${FULL_IMAGE} successfully. Accessible on NodePort 30010."
        }
        failure {
            echo "Pipeline failed. Check stage logs above."
        }
    }
}
