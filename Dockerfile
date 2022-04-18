FROM tomcat:latest
WORKDIR /usr/local/tomcat/
RUN cp -R webapps webapps2
RUN cp -R webapps.dist/* webapps/
COPY ./*.war webapps/

