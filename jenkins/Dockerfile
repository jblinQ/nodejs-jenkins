FROM jenkins/jenkins:lts

USER root
RUN apt-get update -qq \
    && apt-get install -qqy apt-transport-https ca-certificates curl gnupg2 software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
RUN apt-get update  -qq \
    && apt-get -y install docker-ce
RUN usermod -aG docker jenkins

# install kubectl
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl && \
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key \
        | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg && \
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] \
        https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' \
        | tee /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && \
    apt-get install -y kubectl

USER jenkins
# install additional plugins
RUN jenkins-plugin-cli --plugins \
    "blueocean nodejs docker-workflow kubernetes-cli"

EXPOSE 8080 50000
