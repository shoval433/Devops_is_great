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
                    sh "docker-compose build "
                    sh "docker-compose up -d"
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