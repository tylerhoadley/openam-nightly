FROM tomcat:8-jre8

MAINTAINER warren.strange@gmail.com

RUN mkdir -p /tmp/openam_exploded
WORKDIR /tmp/openam_exploded


# download openam nightly build war
# Trick taken from wadahiro/docker-openam-nightly!
RUN curl http://download.forgerock.org/downloads/openam/openam_link.js | \
   grep -o "http://.*\.war" | xargs curl -o /tmp/openam_exploded/openam-org.war

RUN jar xvf /tmp/openam_exploded/openam-org.war
RUN echo "configuration.dir=/opt/openam/config" >> WEB-INF/classes/bootstrap.properties
RUN rm -rf /tmp/openam_exploded/openam-org.war
RUN jar cvf /usr/local/tomcat/webapps/openam.war

ENV CATALINA_HOME=/usr/local/tomcat
ENV PATH=$CATALINA_HOME/bin:$PATH
WORKDIR $CATALINA_HOME

EXPOSE 8080

ADD run-openam.sh /tmp/run-openam.sh
RUN chmod 777 /tmp/run-openam.sh

CMD ["/tmp/run-openam.sh"]
