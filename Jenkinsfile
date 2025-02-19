pipeline {
    agent any
    
    stages {
        stage('Checkout Code') {
            steps {
                git branch: env.GIT_BRANCH, url: 'https://github.com/akash-kumar-s0/terraform-training.git'
            }
        }

        stage('Debug Branch Name') {
            steps {
                script {
                    echo "✅ Current Branch Detected by Jenkins: ${env.GIT_BRANCH}"
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir('day-1/task1&2') { // Ensure correct Terraform directory
                    sh 'terraform init'
                    sh 'echo ${env.GIT_BRANCH}'
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
                expression { env.GIT_BRANCH == 'origin/main' || env.GIT_BRANCH == 'main' }
            }
            steps {
                script {
                    def userInput = input(
                        message: "Approve Terraform Apply?",
                        parameters: [booleanParam(defaultValue: false, description: 'Approve apply?', name: 'Proceed')]
                    )
                    if (!userInput) {
                        error("Terraform Apply Canceled ")
                    }
                }
            }
        }

        stage('Terraform Apply') {
            when {
                branch 'origin/main'
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
