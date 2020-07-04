# NOTE: This file is only present for testing.
# It is not necessary for configuring the Jenkins configuration-as-code plugin

# ======================================================================================================================
# Testing Stage
# ======================================================================================================================
# docker build --target ci .
#
# this stage will validate that the yaml files present in this repo conform to the Jenkins configuration-as-code
# schama, for the plugins specified in plugins.txt
# this can be extracted and moved into a CI system of your choice.

FROM gradle:6.5 as ci
WORKDIR /home/gradle/project
COPY . /home/gradle/project

RUN gradle test


# ======================================================================================================================
# Runtime Stage
# ======================================================================================================================
# docker build --target runtime .

#locking to specific version for repeatibility. Change this to LTS or a more recent version in production.
FROM jenkins/jenkins:2.243 as runtime
# lets disable the startup wizard for automation purposes.
ENV JAVA_OPTS=-Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG=/usr/share/jenkins/init.jcasc.d/

# plugins.txt contains a list of all transient dependencies of the kubernetes plugin.
COPY plugins.txt /usr/share/jenkins/ref/

# copy over JCASC configuration
COPY *.yaml /usr/share/jenkins/init.jcasc.d/

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt


