pipeline {
    agent any

    tools {
        nodejs 'node-v16'
    }

    environment {
        NODEJS_ENV = credentials('app-env-file')
    }

    stages {
        stage('Checkout Source') {
            steps {
                cleanWs()
                git credentialsId: 'github-credential', url: 'https://github.com/jomoflash/node-app.git', branch: "${env.BRANCH_NAME}"
                echo "Pulled ${env.BRANCH_NAME}"
            }
        }
        stage('Install dependencies') {
            steps {
                script {
                        nodejs('node-v16') {
                            sh 'yarn install'
                        }
                }
            }
        }
        stage('Add .env file') {
            steps {
                dir('src/config/') {
                    script {
                        sh 'cp ${NODEJS_ENV} .env'
                        // sh 'cat .env'
                        sh 'ls -a'
                    }
                }
            }
        }
        stage('Run test suites') {
            steps {
                script {
                    nodejs('node-v16') {
                            sh 'yarn test'
                    }
                }
            }
        }
        stage('Build and push docker images') {
                parallel {
                    stage('Build dev image') {
                        when { not { anyOf { branch 'main' } } }
                            steps {
                                script {
                                    myapp = docker.build("jomoflash/node-app:dev-${env.BUILD_ID}")
                                    // env.image = "jomoflash/node-app:latest"
                                    env.image = "jomoflash/node-app:dev-${env.BUILD_ID}"

                                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-credential') {
                                        myapp.push('latest')
                                        myapp.push("dev-${env.BUILD_ID}")
                                    }

                                    sh 'echo "Successfully pushed image to docker registry"'
                                }
                            }
                    }
                    stage('Build prod image') {
                        when { branch 'main' }
                            steps {
                                script {
                                    myapp = docker.build("jomoflash/node-app:prod-${env.BUILD_ID}")
                                    // env.image = "jomoflash/node-app:latest"
                                    env.image = "jomoflash/node-app:prod-${env.BUILD_ID}"

                                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-credential') {
                                        myapp.push('latest')
                                        myapp.push("prod-${env.BUILD_ID}")
                                    }

                                    sh 'echo "Successfully pushed image to docker registry"'
                                }
                            }
                    }
                }
        }
        // stage("Push image") {
        //     steps {
        //         script {
        //             docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-credential') {
        //                     myapp.push("latest")
        //                     myapp.push("${env.BUILD_ID}")
        //             }
        //             sh 'echo "Successfully pushed image to docker registry"'
        //         }
        //     }
        // }
        stage('Deploy to k8s') {
            parallel {
                stage('deploy dev') {
                    when { not { anyOf { branch 'main' } } }
                        steps {
                            echo 'Deploying now...'
                            sh "sed -i 's~__NAMESPACE__~dev~g' manifest.yaml"
                            sh "sed -i 's~__IMAGE__~${image}~g' manifest.yaml"

                            withKubeConfig([credentialsId: 'kube-config']) {
                                sh 'echo $KUBECONFIG'
                                sh 'kubectl get deployments'
                                sh 'kubectl apply -f manifest.yaml'
                            }
                        }
                }
                stage('deploy prod') {
                    when { branch 'main' }
                    steps {
                            echo 'Deploying to prod...'
                            sh "sed -i 's~__NAMESPACE__~prod~g' manifest.yaml"
                            sh "sed -i 's~__IMAGE__~${image}~g' manifest.yaml"

                            withKubeConfig([credentialsId: 'kube-config']) {
                                sh 'echo $KUBECONFIG'
                                sh 'kubectl get deployments'
                                sh 'kubectl apply -f manifest.yaml'
                            }
                    }
                }
            }
        }
    }
}
