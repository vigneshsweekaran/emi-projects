FROM ubuntu:16.04
RUN apt-get update &&apt-get install -y git curl wget && rm -rf /var/lib/apt/lists/*
ENV AGENT_VERSION 2.3.6
ENV PACKAGE_NAME agentctl-${AGENT_VERSION}-linux-x64-full.tgz
#ENV PACKAGE_URL https://s3.amazonaws.com/qTest-storage/qTest-automation/${AGENT_VERSION}/$PACKAGE_NAME
ENV PACKAGE_URL https://qasymphony.jfrog.io/artifactory/launch-release-local/automation-hosts/agentctl/${AGENT_VERSION}/agentctl-${AGENT_VERSION}-linux-x64-full.tgz
ENV AGENT_HOME /usr/local
ENV FOLDER_NAME agentctl-${AGENT_VERSION}
ENV PORT 6789

WORKDIR $AGENT_HOME

RUN set -x \
  && wget --no-check-certificate "$PACKAGE_URL" \
  && tar xvzf $PACKAGE_NAME -C $AGENT_HOME \
  && rm $PACKAGE_NAME \
  && mv agentctl-${AGENT_VERSION} agentctl

# install a junit sample
COPY ./junit-sample ${AGENT_HOME}/junit-sample/

# configure host
RUN ./agentctl/agentctl config -Phost=0.0.0.0 -Pport=${PORT}

EXPOSE $PORT

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod u+wrx /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]