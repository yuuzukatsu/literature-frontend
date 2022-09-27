def branch = "production"
def remoteurl = "https://github.com/yuuzukatsu/literature-frontend.git"
def remotename = "jenkins"
def workdir = "~/literature-frontend/"
def ip = "10.71.15.183"
def username = "dimasf"
def imagename = "yuuzukatsu/literature-frontend:latest"
def sshkeyid = "app-key"
def composefile = "frontend-compose.yml"

pipeline {
    agent any

    stages {
        stage('Pull From Frontend Repo') {
            steps {
                sshagent(credentials: ["${sshkeyid}"]) {
                    sh """
                        ssh -l ${username} ${ip} <<pwd
                        cd ${workdir}
                        git remote add ${remotename} ${remoteurl} || git remote set-url ${remotename} ${remoteurl}
                        git pull ${remotename} ${branch}
                        pwd
                    """
                }
            }
        }
            
        stage('Build Docker Image') {
            steps {
                sshagent(credentials: ["${sshkeyid}"]) {
                    sh """
                        ssh -l ${username} ${ip} <<pwd
                        cd ${workdir}
                        docker build -t ${imagename} .
                        pwd
                    """
                }
            }
        }
            
        stage('Deploy Image') {
            steps {
                sshagent(credentials: ["${sshkeyid}"]) {
                    sh """
                        ssh -l ${username} ${ip} <<pwd
                        cd ${workdir}
                        // docker compose -f ${composefile} down
                        docker compose -f ${composefile} up -d
                        pwd
                    """
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                sshagent(credentials: ["${sshkeyid}"]) {
                    sh """
                        ssh -l ${username} ${ip} <<pwd
                        docker image push ${imagename}
                        docker image prune -f --all
                        pwd
                    """
                }
            }
        }


        stage('Send Success Notification') {
            steps {
                sh """
                    curl -X POST 'https://api.telegram.org/bot${env.telegramapi}/sendMessage' -d \
		    'chat_id=${env.telegramid}&text=Build ID #${env.BUILD_ID} Frontend Pipeline Successful!'
                """
            }
        }

    }
}
