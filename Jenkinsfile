pipeline{

    agent any
 environment{
       def IP="app_lab_app_1"
       def PORT=80
      

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
                        sh "mkdir logging"
                        sh "docker bulid -t test-img"
                        sh "docker run --name tests -e ip=${IP} -e port=${PORT} --network for_app -v ./logging:/test/logs -d "
                        sh "cat logging/test.log"
                    }
                }

            }
        }


        
    }
    
    post{
        always{
            script{
                 sh "docker-compose down "
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