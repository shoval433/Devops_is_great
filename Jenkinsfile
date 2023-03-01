pipeline{

    agent any

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
                    sh "docker-compose bulid "
                    sh "docker-compose run -d"
                }
            }
        }

        
    }
    
    post{
        success{
           echo "yes"
        }
        failure {
            echo "no"
            
        }
    }
}