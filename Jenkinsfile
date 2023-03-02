pipeline{

    agent any
environment{
    def IP="app_lab_app_1"
    def PORT="5000"
    def TAGcommit=""
    def TAG=""
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
                    sh "docker-compose build --no-cache"
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
                        sh "docker build -t test-img . --no-cache"
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
                    sh "git fetch --tags"
                    dir('script'){
                        TAG=sh (script: "bash calc.sh",
                        returnStdout: true).trim()
                    }
                    echo "${TAG}"
                    tag_befor=sh (script: 'echo $(git tag) |rev| cut -d " " -f2 | rev',
                    returnStdout: true).trim()
                    // #test
                    if(tag_befor==TAG || tag_befor ==""){
                        if(tag_befor==TAG){
                            echo "same tag"
                        }
                        else if(tag_befor ==""){
                           echo "first tag" 
                        //    work
                           sh "git tag"
                           withCredentials([gitUsernamePassword(credentialsId: 'my_git', gitToolName: 'Default')]){
                            sh "git tag $TAG"
                            sh "git push origin $TAG"
                            }
                        }
                    }
                    else{
                        echo "have before" 
                        // #push tag
                        dir('script'){
                            sh "./tag_check.sh $TAG"
                        }
                        withCredentials([gitUsernamePassword(credentialsId: 'my_git', gitToolName: 'Default')]){
                        sh "git tag $TAG"
                        sh "git push origin $TAG"
                        }
                    }
                        
                    
                    
                }     
                
            }


        }
        stage("tagTEST"){
            steps{
                echo "========executing TESTTAG========"
                script{
                    sh 'git tag'
                    echo '=========================================================='
                    sh "git describe --tags"


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
        success{
           echo "yes"
        }
        failure {
            echo "no"
            
        }
    }
}