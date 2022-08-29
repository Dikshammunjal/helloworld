pipeline {
    agent any
    tools { 
      maven 'MAVEN_HOME' 
      jdk 'JAVA_HOME' 
    }
    stages {
        
        stage('Build') { 
            steps {
                sh "pwd"

                    sh ("pwd")
                    sh ("ls -ltr")
                  sh("mvn clean package -DskipTests")
                sh ("cp /u01/shared/var/jenkins_home/jobs/test1/workspace/target/*.jar /home/jenkins/workspace/test1/")
                    
                

            }
        }
        stage('Create docker image') {
            agent {
            node {
            label 'agent-label'
            }
            }
            steps {
                script {
                    def scmVars = checkout([
                        $class: 'GitSCM',
                        doGenerateSubmoduleConfigurations: false,
                        userRemoteConfigs: [[
                            url: "${params.GIT_REPO_URL}"
                          ]],
                        branches: [ [name: "*/${params.GIT_REPO_BRANCH}"] ]
                      ])
                    
                    
                   sh ("pwd")
                   sh ("ls -ltr")
                   sh ("sleep 10000")
                   sh "docker build -f Dockerfile -t ${params.MIRCROSERVICE_NAME}:${scmVars.GIT_COMMIT} ." 



                    
                
    
                
                }
            }
        }
        stage('Push image to OCIR') { 
            agent {
            node {
            label 'agent-label'
            }
            }
            steps {
                script {
                    def scmVars = checkout([
                        $class: 'GitSCM',
                        doGenerateSubmoduleConfigurations: false,
                        userRemoteConfigs: [[
                            url: "${params.GIT_REPO_URL}"
                          ]],
                        branches: [ [name: "*/${params.GIT_REPO_BRANCH}"] ]
                      ])
                sh "docker login -u ${params.REGISTRY_USERNAME} -p ${params.REGISTRY_TOKEN} ${params.REGION}.ocir.io"
                sh "docker tag ${params.MIRCROSERVICE_NAME}:${scmVars.GIT_COMMIT} ${params.DOCKER_REPO}:${scmVars.GIT_COMMIT}"
                sh "docker push ${params.DOCKER_REPO}:${scmVars.GIT_COMMIT}" 
                env.GIT_COMMIT = scmVars.GIT_COMMIT
                sh "export GIT_COMMIT=${env.GIT_COMMIT}"
                echo "${params.REGISTRY_USERNAME}"
             
                echo "${params.DOCKER_REPO}:${scmVars.GIT_COMMIT}"
                env.USERNAME="${params.REGISTRY_USERNAME}"
                env.PASSWORD="${params.REGISTRY_TOKEN}"
                env.IMAGE="${params.DOCKER_REPO}:${scmVars.GIT_COMMIT}"
                env.MICROSERVICENAME=  "${params.MIRCROSERVICE_NAME}"
                env.REGIONNAME= "${params.REGION}"
                env.EMAILID = "${params.REGISTRY_EMAIL}"
                env.PORT ="${params.PORT}"
                }
               }
            }
        stage('Deploy OKE') { 
            agent {
            node {
            label 'agent-label'
            }
            }
            steps {
            sh 'git clone https://github.com/Dikshammunjal/base_oke_template_jenkins.git'
            echo 'Deploy app to OKE Cluster'


            
            sh '/u01/shared/scripts/pipeline/microservices/base_oke_template_jenkins/update_deploy_microservices.sh $REGIONNAME.ocir.io $USERNAME $PASSWORD $EMAILID $MICROSERVICENAME-ns $MICROSERVICENAME $IMAGE $PORT $MICROSERVICENAME-svc'
                
               }
            }
        
        
        
        }
}
