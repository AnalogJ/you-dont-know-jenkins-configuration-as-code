# NOTE: This file is only present for testing.
# It is not necessary for configuring the Jenkins configuration-as-code plugin

FROM jenkins/jenkins:lts

# lets disable the startup wizard for automation purposes.
ENV JAVA_OPTS=-Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG=/usr/share/jenkins/init.jcasc.d/

# plugins.txt contains a list of all transient dependencies of the kubernetes plugin.
COPY plugins.txt /usr/share/jenkins/ref/

# copy over JCASC configuration
COPY *.yaml /usr/share/jenkins/init.jcasc.d/

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt


