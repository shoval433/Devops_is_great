
# Devops_is_great

## App
This project prints "Devops is great" to adapt to the environment you are running in (in this example we are talking about localhost)

## Pipline
Inside the repository you can find the jenkinsfile that follows the project's continuous integration process


## Environment Variables in Jenkinsfile

Inside the jenkinsfile we have some Environment Variables that are important to refer to.

#### Test related
`IP`
`PORT`
#### Tag related
`TAG`
`TAGcommit`
#### Notice related
`NAME`
`EMAIL`
## Jenkins CI
#### Pull
- Completely deletes the old environment(deleteDir()).
- Pulling the code from the github repository(checkout scm).

#### Build

- Building the app.

#### Test

- Doing tests on an application.

#### Tag calculation

- We will enter this stage only if the commit also has "#tag", This stage was created to give Jenkins the responsibility to perform version control.

- that stage handles end conditions, For example if the developer sends a tag and "#tag"

#### Tag validity

- Checking the history of the tag including the new ones (in case they were pushed).

#### Publish
- Notifies whether the CI passed or not.
## Run Locally

 ### To run the application
```bash
  docker-compose build
```
```bash
  docker-compose up -d
```
 ### To run the tests
Go to the project directory

```bash
  cd tests
```
```bash
  docker build -t test-img .
```
You must transfer the IP and PORT you are running the application on (default is port 80)
```bash
  docker run --name test -e ip=${IP} -e port=${PORT} --network app_lab_for_app test-img
```
### To run a jenkins server
```bash
  cd jenkins
```
```bash
  ./run.sh
```


## 🦑 About Me
My name is Shoval and i am DevOps Engineer focuses on deploying, automating, and maintaining cloud-based and on-premise infrastructure. I have a diverse skillset, having worked with a wide range of technologies, including AWS, Azure, Terraform, Jenkins,Artifactory, Git, Docker, Nginx, Python, Bash, and SQL.


## 🔗 Links
[![portfolio](https://img.shields.io/badge/my_portfolio-000?style=for-the-badge&logo=ko-fi&logoColor=white)](https://github.com/shoval433/freediving_comp2.0)
[![linkedin](https://img.shields.io/badge/linkedin-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](www.linkedin.com/in/shoval-astamker-4149a6202)

