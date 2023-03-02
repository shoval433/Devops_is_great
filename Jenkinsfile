pipeline{

    agent any
environment{
    IP="app_lab_app_1"
    PORT="5000"
    TAGcommit=""
    TAG=""
    NAME=""
    EMAIL=""
   }
    stages{
        stage("chekout"){
            steps{
                echo "========executing chekout========"
                deleteDir()
                checkout scm
            }
        }
        stage("bulid"){
            steps{
                echo "========executing chekout========"
                script{
                    sh "docker-compose build "
                    sh "docker-compose up -d"
                }
            }
        }
        stage("test"){
            steps{
                echo "========executing E2E========"
                script{
                    app_ip=sh(returnStdout: true, 
                    script: 'docker inspect app_lab_app_1 | grep -w "IPAddress" | cut -d \'"\' -f 4 ').trim()
                    dir('tests'){
                        sh "docker ps"
                        echo "------------------------------------------"
                        sh "docker network ls"
                        echo "------------------------------------------"
                        sh "docker build -t test-img . "
                        sh "docker run --name test -e ip=${IP} -e port=${PORT} --network app_lab_for_app test-img"
                    }
                    TAGcommit=sh (script: "git show -s --format=%s",
                    returnStdout: true).trim()
                }

            }
        }

        stage("Tag"){
            when {
                expression{
                    return TAGcommit.contains("#tag")
                }
            }
            steps{
                echo "========executing TAG========"
                 script{
                    NAME=sh (script: "git log --pretty=format:'%an' --max-count=1",
                    returnStdout: true).trim()
                    
                    EMAIL=sh (script: "git log -1 --pretty=format:'%ae'",
                    returnStdout: true).trim()
                    

                    sh "git fetch --tags"
                    dir('script'){
                        TAG=sh (script: "bash calc.sh",
                        returnStdout: true).trim()
                    }
                    echo "${TAG}"
                    echo "=============test_commit================"
                    last_of_all=sh (script: 'echo $(git tag) |rev| cut -d " " -f1 | rev',
                    returnStdout: true).trim()

                    last_has=sh (script: 'git rev-parse --short HEAD',
                    returnStdout: true).trim()
                    
                    last_tag_has=sh (script: "git tag -l --format='%(refname:short) %(objectname:short)' | tail -n 1 | cut -d ' ' -f2",
                    returnStdout: true).trim()

                    if(last_of_all==""){
                        echo "first tag" 
                        sh "git tag"
                        withCredentials([gitUsernamePassword(credentialsId: 'my_git', gitToolName: 'Default')]){
                        sh "git tag $TAG"
                        sh "git push origin $TAG"
                        } 
                    }
                    else if(last_tag_has!=last_has) {
                        echo "new tag on commit" 
                        dir('script'){
                            sh "./tag_check.sh $TAG"
                        }
                        withCredentials([gitUsernamePassword(credentialsId: 'my_git', gitToolName: 'Default')]){
                        sh "git tag $TAG"
                        sh "git push origin $TAG"
                        }
                    }
                    else{
                        echo "Pipline No Tag That"
                        dir('script'){
                            sh "./tag_check.sh $last_of_all"
                        }
                    }
                    sh "git log --pretty=format:'%an <%ae> pushed to the repository' --max-count=1"
                    sh "git log -1 --pretty=format:'%ae'"
                    
                }    
               
            }
            post{
                success{
                    echo "====++++only when successful++++===="
                    echo "The tag is good"
                }
                failure{
                    echo "====++++only when failed++++===="
                    sh "git log --pretty=format:'Invalid tag Please notify %an on that' --max-count=1"
                    
                }
            }


        }
        stage("tagTEST"){
             when {
                expression{
                    return !(TAGcommit.contains("#tag"))
                }
            }
            steps{
                echo "========executing TEST_TAG========"
                script{
                    NAME=sh (script: "git log --pretty=format:'%an' --max-count=1",
                    returnStdout: true).trim()
                    
                    EMAIL=sh (script: "git log -1 --pretty=format:'%ae'",
                    returnStdout: true).trim()
                    

                    last_of_all=sh (script: 'echo $(git tag) |rev| cut -d " " -f1 | rev',
                    returnStdout: true).trim()
                    if(last_of_all != ""){
                    dir('script'){
                            sh "./tag_check.sh $last_of_all"
                    }
                        
                    }
                    
                }
            }
            post{
                success{
                    echo "====++++only when successful++++===="
                    echo "The tag is good"
                }
                failure{
                    echo "====++++only when failed++++===="
                    sh "git log --pretty=format:'Invalid tag Please notify %an on that' --max-count=1"
                }
            }
        }

        
    }
    
    post{
        always{
            script{
                sh "docker rm -f test"
                sh "docker-compose down -v"
            }
        }
        // GIT_COMMITTER_EMAIL
        success{
            emailext   to: "${EMAIL}",
                subject: 'YOU ARE BETTER THEN THAT !!! ', body: 'Dear ${env.NAME}, you have broken the code, you are asked to immediately sit on the chair and leave the coffee corner.',  
                attachLog: true
        }
        failure {
            emailext   to: "${EMAIL}" ,
                subject: 'YOU ARE BETTER THEN THAT !!! ', body: 'Dear ${env.NAME}, you have broken the code, you are asked to immediately sit on the chair and leave the coffee corner.',  
                attachLog: true
            
        }
    }
}