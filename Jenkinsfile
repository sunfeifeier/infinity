#!/usr/bin/env groovy

pipeline {
    // You can specify agent label in later stage
    agent none
    options {
        parallelsAlwaysFailFast()
    }
    stages {
        stage('init') {
            steps {
                println "Build started"
            }
        }
        stage('Linux CICD') {
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
                                    // env.WORKSPACE = pwd()
                                    // def version = readFile "${env.WORKSPACE}/build.info"
                                    // version = version.replaceAll("\n", "");
                                    // println "Version is $version"
                                    // sh label: 'Publish file', script: "deploy to you package management system"
                                    sh label: 'build', script: '''
                                    echo "Deploy to s3 bucket..."
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
                                    # source venv/bin/activate
                                    # export PYTHONPATH="./app"
                                    # nohup uvicorn main:app --host 0.0.0.0 &
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