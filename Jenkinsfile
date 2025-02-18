pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-credentials')
        AWS_SECRET_ACCESS_KEY = credentials('aws-credentials')
    }
    
    stages {
        stage('Checkout Code') {
            steps {
                git branch: env.BRANCH_NAME, url: 'https://github.com/akash-kumar-s0/terraform-training.git'
            }
        }

        stage('Terraform Init') {
            steps {
                dir('day-1/task1&2') { // Ensure correct Terraform directory
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('day-1/task1&2') {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Approval Check') {
            when {
                branch 'main'
            }
            steps {
                script {
                    def userInput = input(
                        message: "Approve Terraform Apply?",
                        parameters: [booleanParam(defaultValue: false, description: 'Approve apply?', name: 'Proceed')]
                    )
                    if (!userInput) {
                        error("Terraform Apply Canceled")
                    }
                }
            }
        }

        stage('Terraform Apply') {
            when {
                branch 'main'
            }
            steps {
                dir('day-1/task1&2') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }
    
    post {
        always {
            echo "Pipeline execution completed."
        }
    }
}