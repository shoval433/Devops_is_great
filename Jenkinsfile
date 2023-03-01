pipeline{

    agent any
 environment{
       def IP="app_lab_app_1"
       def PORT="5000"
      

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
                        sh "mkdir logging"
                        sh "docker build -t test-img ."
                        sh "docker run --name tests -e ip=${IP} -e port=${PORT} --network app_lab_for_app -v ~/workspace/app_lab/tests/logging:/test/logging test-img "
                        sh "cat logging/test.log"
                    }
                }

            }
        }

        stage("Tag"){
            steps{
                echo "========executing TAG========"
                // deleteDir()
                // checkout scm
            }
        }


        
    }
    
    post{
        always{
            script{
                sh "docker rm -f tests"
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