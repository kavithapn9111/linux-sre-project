pipeline {
    agent any

    stages {
        stage('Clone Repo') {
            steps {
                git 'https://github.com/YOUR_USERNAME/linux-sre-project.git'
            }
        }

        stage('Install Python') {
            steps {
                sh 'sudo apt install python3 -y'
            }
        }

        stage('Deploy App') {
            steps {
                sh 'bash scripts/deploy.sh'
            }
        }
    }
}
