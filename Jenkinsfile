pipeline {
    agent any
    environment {
        AWS_ACCOUNT_ID = '692859914450'
        AWS_REGION = 'us-east-2'
        IMAGE_NAME = 'insurance_app'
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_NAME}"
    }
    
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'master', url: 'https://github.com/Sanjaysaravanan20/Insurance-CI-CD.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${IMAGE_NAME}:latest")
                }
            }
        }

        stage('Push to AWS ECR') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-credentials', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    script {
                        sh """
                        aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                        aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                        aws configure set region ${AWS_REGION}

                        aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${REPOSITORY_URI}
                        docker tag ${IMAGE_NAME}:latest ${REPOSITORY_URI}:latest
                        docker push ${REPOSITORY_URI}:latest
                        """
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['ssh-key']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no ubuntu@18.191.171.4 << EOF
                    ./deploy.sh
                    EOF
                    '''
                }
            }
        }
    }
}
