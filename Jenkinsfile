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
                sh 'docker build -t ${IMAGE_NAME}:latest .'
            }
        }

        stage('Push to AWS ECR') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-credentials', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh """
                    aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${REPOSITORY_URI}
                    docker tag ${IMAGE_NAME}:latest ${REPOSITORY_URI}:latest
                    docker push ${REPOSITORY_URI}:latest
                    """
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['ssh-key']) {
                    script {
                        sh '''
                        echo "Checking if deploy.sh exists in Jenkins workspace..."
                        if [ ! -f deploy.sh ]; then
                            echo "Error: deploy.sh not found in Jenkins workspace!"
                            exit 1
                        fi

                        echo "Transferring deploy.sh to EC2..."
                        scp -o StrictHostKeyChecking=no deploy.sh ubuntu@18.191.171.4:/home/ubuntu/deploy.sh

                        echo "Executing deploy.sh on EC2..."
                        ssh -o StrictHostKeyChecking=no ubuntu@18.191.171.4 << 'EOF'
                        chmod +x /home/ubuntu/deploy.sh
                        /home/ubuntu/deploy.sh
                        EOF
                        '''
                    }
                }
            }
        }
    }
}
