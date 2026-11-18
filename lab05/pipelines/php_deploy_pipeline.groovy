pipeline {
    agent {
        label 'ansible-agent'
    }

    options {
        skipDefaultCheckout(true)
        disableConcurrentBuilds()
    }

    stages {
        stage('Checkout deployment files') {
            steps {
                deleteDir()
                checkout scm
            }
        }

        stage('Clone PHP project') {
            steps {
                dir('php-project') {
                    git branch: 'main',
                        url: 'https://github.com/Eredin1272/containers08.git'
                }
            }
        }

        stage('Deploy PHP project') {
            steps {
                dir('lab05/ansible') {
                    sh 'ansible-playbook -i hosts.ini deploy_php.yml --syntax-check'

                    sshagent(credentials: ['ansible-test-server']) {
                        sh 'ansible-playbook -i hosts.ini deploy_php.yml'
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'PHP-приложение размещено на тестовом сервере.'
        }
        failure {
            echo 'Ошибка размещения PHP-приложения.'
        }
    }
}