# Build the WAR from source in a reproducible Maven/JDK environment.
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /workspace
COPY pom.xml ./
COPY server/pom.xml ./server/pom.xml
COPY webapp/pom.xml ./webapp/pom.xml
RUN mvn --batch-mode --no-transfer-progress -N dependency:go-offline
COPY server ./server
COPY webapp ./webapp
RUN mvn --batch-mode --no-transfer-progress -DskipTests=false clean package

# The application uses javax.servlet APIs, so run it on Tomcat 9 (not Tomcat 10+).
FROM tomcat:9.0-jdk17-temurin
LABEL org.opencontainers.image.title="hello-world-webapp"
LABEL org.opencontainers.image.description="Hello World Maven WAR demo application"
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /workspace/webapp/target/webapp.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=5s --start-period=45s --retries=3 CMD ["bash", "-c", "exec 3<>/dev/tcp/127.0.0.1/8080"]
CMD ["catalina.sh", "run"]
