

  sleep 120

  #PATH="/var/jenkins_home/jenkinsfile_backup/"
  PATH="/temp"

  for i in $(ls $PATH)
  do
    java -jar /var/jenkins_home/jenkins-cli.jar -s http://localhost:8080/ create-job $i < $PATH/$i.xml
  done
