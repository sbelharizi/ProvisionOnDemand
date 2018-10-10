FROM jenkins/jenkins:lts

USER jenkins

RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state
COPY --chown=jenkins:jenkins jenkins-cli.jar /var/jenkins_home

COPY --chown=jenkins:jenkins jenkins-plugin-list /usr/share/jenkins/ref/
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/jenkins-plugin-list

#COPY --chown=jenkins:jenkins job/create-job.sh /var/jenkins_home
#
#USER root
#RUN  cat /var/jenkins_home/create-job.sh >> /usr/local/bin/jenkins.sh
#USER jenkins
#
#COPY --chown=jenkins:jenkins temp /var/jenkins_home/jenkinsfile_backup
