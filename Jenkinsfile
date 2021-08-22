#!/usr/bin/env groovy

pipeline {
    // You can specify agent label in later stage
    agent none
    options {
        // Set failfast true for all subsequent parallel stages
        // so you don't have to wait for all parallel stages to fail
        // For this job to fail
        parallelsAlwaysFailFast()
    }
    stages {
        stage('init') {
            steps {
                println "Build started"
            }
        }
        stage('CICD') {
            parallel {
                stage('linux') {
                    agent {
                        label "master"
                    }
                    stages {
                        // Active the Python virtual env
                        stage('setup') {
                            steps {
                                sh label: 'Active python venv', script: '''
                                    echo "==========Create virtual env=========="
                                    python3.8 -m venv venv
                                    source venv/bin/activate
                                    pip install --upgrade pip
                                    if [ ! -f ./requirements2.txt ]; then
                                        echo "Couldn'f find requirements.txt
                                    fi
                                    pip install -r requirements.txt
                                    echo "==========End virtual env=========="
                                    '''
                            }
                        }
                        stage('build') {
                            steps {
                                sh label: 'build', script: '''
                                    echo "==========Testing and building=========="
                                    export PYTHONPATH="./app"
                                    python -m unittest
                                    echo "==========Testing and building=========="
                                    source venv/bin/activate
                                    python setup.py bdist_wheel
                                    ls
                                    '''
                            }
                        }
                        stage('deploy') {
                            when {
                                branch 'main'
                            }
                            steps {
                                script {
                                    sh label: 'build', script: '''
                                    echo "Deploy to s3 bucket..."
                                    VERSION=`cat app/VERSION`
                                    aws s3 cp dist/infinity-$VERSION* s3://usc-tony-infinity-us-east-1/
                                    '''
                                }
                            }
                        }
                        stage('run') {
                            when {
                                branch 'main'
                            }
                            steps {
                                script {
                                    sh label: 'build', script: '''
                                    echo "Download package from s3 bucket..."
                                    VERSION=`cat app/VERSION`
                                    aws s3 cp s3://usc-tony-infinity-us-east-1/infinity-$VERSION-py3-none-any.whl /tmp
                                    source venv/bin/activate
                                    which pip
                                    pip install /tmp/infinity-$VERSION-py3-none-any.whl
                                    pip list
                                    export PYTHONPATH="./app"
                                    cd app
                                    pwd
                                    nohup uvicorn main:app --host 0.0.0.0 --port 8000 &
                                    '''
                                }
                            }
                        }
                    }
                    post {
                        // Slack notifications
                        success {
                            sh label: 'success', script: 'echo "Success"'
                            slackSend channel: 'jenkins-noti', color: 'good', message: "<${env.BUILD_URL}|${env.JOB_NAME} #${env.BUILD_NUMBER}> - Build completed successfully"
                        }
                        failure {
                            sh label: 'failure', script: 'echo "Failure"'
                            slackSend channel: 'jenkins-noti', color: 'danger', message: "<${env.BUILD_URL}|${env.JOB_NAME} #${env.BUILD_NUMBER}> - Build failed"
                        }
                        aborted {
                            sh label: 'aborted', script: 'echo "Aborted"'
                            slackSend channel: 'jenkins-noti', color: 'danger', message: "<${env.BUILD_URL}|${env.JOB_NAME} #${env.BUILD_NUMBER}> - Build aborted"
                        }
                        always {
                            sh label: 'Linux build done', script: 'echo "Done Linux build"'
                            //cleanWs()//
                        }
                    }
                }
            }
        }
    }
}