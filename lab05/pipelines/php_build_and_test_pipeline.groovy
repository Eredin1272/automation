pipeline {
    agent {
        label 'php-agent'
    }

    options {
        skipDefaultCheckout(true)
    }

    stages {
        stage('Clone PHP project') {
            steps {
                deleteDir()

                git branch: 'main',
                    url: 'https://github.com/Eredin1272/containers08.git'
            }
        }

        stage('Install dependencies') {
            steps {
                sh 'composer install --no-interaction --prefer-dist --no-progress'
            }
        }

        stage('Run tests') {
            steps {
                sh 'mkdir -p build'

                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    sh 'vendor/bin/phpunit --log-junit build/phpunit.xml'
                }
            }
        }

        stage('Publish test results') {
            steps {
                junit testResults: 'build/phpunit.xml',
                      allowEmptyResults: false
            }
        }
    }

    post {
        success {
            echo 'Все тесты успешно пройдены.'
        }
        failure {
            echo 'Сборка или тестирование завершились с ошибкой.'
        }
    }
}