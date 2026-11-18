pipeline {
    agent {
        label 'ansible-agent'
    }

    options {
        skipDefaultCheckout(true)
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Configure test server') {
            steps {
                dir('lab05/ansible') {
                    sh 'ansible-playbook -i hosts.ini setup_test_server.yml --syntax-check'

                    sshagent(credentials: ['ansible-test-server']) {
                        sh 'ansible-playbook -i hosts.ini setup_test_server.yml'
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Тестовый сервер настроен.'
        }
        failure {
            echo 'Ошибка настройки тестового сервера.'
        }
    }
}