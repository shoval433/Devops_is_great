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
        // Cleans up the environment and pulls the code
        stage("chekout"){
            steps{
                echo "========executing chekout========"
                deleteDir()
                checkout scm
            }
        }
        // Building the application
        stage("bulid"){
            steps{
                echo "========executing chekout========"
                script{
                    sh "docker-compose build --no-cache  "
                    sh "docker-compose up -d"
                }
            }
        }
        // Testing the app
        stage("test"){
            steps{
                echo "========executing E2E========"
                script{
                    app_ip=sh(returnStdout: true, 
                    script: 'docker inspect app_lab_app_1 | grep -w "IPAddress" | cut -d \'"\' -f 4 ').trim()
                    dir('tests'){
                        sh "docker build -t test-img . --no-cache  "
                        sh "docker run --name test -e ip=${IP} -e port=${PORT} --network app_lab_for_app test-img"
                    }
                    TAGcommit=sh (script: "git show -s --format=%s",
                    returnStdout: true).trim()
                }

            }
        }
        // If there is a "#tag" in the commit's message,
        // then the pipelin takes care of the Version management according to previous tags.
        // Also refers to end conditions if a tag is pushed in addition.
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
                    
                    echo "=============test_has_commit================"
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
                        echo "Pipeline No Tag That"
                        dir('script'){
                            sh "./tag_check.sh $last_of_all"
                        }
                    }
                    
                }    
               
            }
            post{
                success{
                    echo "====successful++++===="
                    echo "The tag is good"
                }
                failure{
                    echo "====failed++++===="
                    sh "git log --pretty=format:'Invalid tag Please notify %an on that' --max-count=1"
                    emailext  body: 'Dear '+NAME+', your tag is Invalid'+last_of_all,
                    to: EMAIL, subject: NAME+' YOU ARE BETTER THEN THAT !!!'
                }
            }


        }
        // If there is no "#tag", we check if the order of the tags is correct,
        // and if not, we will inform the devloper who did it
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
                    echo "====successful++++===="
                    echo "The tag is good"
                    
                }
                failure{
                    echo "====failed++++===="
                    sh "git log --pretty=format:'Invalid tag Please notify %an on that' --max-count=1"
                    emailext  body: 'Dear '+NAME+', your tag is Invalid'+last_of_all,
                    to: EMAIL, subject: NAME+' YOU ARE BETTER THEN THAT !!!'
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
        // Uses the emailext plugin to send the emails
        success{
            script{
               emailext attachLog: true, body: 'Well, this time you didnt mess up', to: EMAIL, subject: NAME+' Congratulations!'
            }
        }
        failure {
            script{
                emailext attachLog: true, body: 'Dear '+NAME+', you have broken the code, you are asked to immediately sit on the chair and leave the coffee corner.',
                to: EMAIL, subject: NAME+' YOU ARE BETTER THEN THAT !!!'
            }
           
        }
    }
}