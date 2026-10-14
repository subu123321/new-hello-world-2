# Hello World Maven Web Application

A Java 17, multi-module Maven project that packages a WAR and builds a Docker image for Jenkins and Azure DevOps pipelines.

## Project layout

- `pom.xml`: parent/aggregator POM for both modules.
- `server/`: reusable Java library and JUnit tests.
- `webapp/`: JSP/Servlet web application packaged as `webapp.war`.
- `Dockerfile`: multi-stage Maven build followed by Tomcat 9 runtime.
- `sonar-project.properties`: standalone SonarScanner CLI settings. Maven builds should use `mvn sonar:sonar` instead.
- `Jenkinsfile`: build/test/package, optional SonarQube analysis, WAR archive, Docker image build.
- `azure-pipelines.yml` and `pipeline.yaml`: equivalent Azure DevOps pipeline definitions. Use either file in Azure DevOps; `azure-pipelines.yml` is the default convention, while `pipeline.yaml` is included as requested.

## Requirements

- JDK 17
- Maven 3.9 or newer
- Docker Engine for image build/run

## Build WAR locally

From the repository root:

```bash
mvn --batch-mode --no-transfer-progress clean verify
```

The WAR is generated at:

```text
webapp/target/webapp.war
```

To compile and package without tests (not recommended for CI):

```bash
mvn --batch-mode --no-transfer-progress -DskipTests clean package
```

## Build and run Docker image

```bash
docker build -t hello-world-webapp:1.0 .
docker run --rm --name hello-world-webapp -p 8080:8080 hello-world-webapp:1.0
```

Open `http://localhost:8080`.

The application uses `javax.servlet` APIs and therefore targets Tomcat 9. Do not switch to Tomcat 10+ without migrating the application to `jakarta.servlet` APIs.

## Jenkins

Configure Jenkins Global Tool Configuration with tool names exactly `JDK17` (JDK 17) and `Maven3` (Maven 3.9+). Ensure the agent has Docker installed and permission to build images.

SonarQube is optional. To enable it, configure a SonarQube installation named `SonarQube` under **Manage Jenkins > System**, and run the job with `RUN_SONAR=true`. The project key is `SubuDemo`; change it in the Jenkinsfile if your server uses another key. Do not hard-code tokens in source control.

## Azure DevOps

Use either `azure-pipelines.yml` or `pipeline.yaml` as the pipeline YAML path when creating an Azure DevOps pipeline. Both definitions run on `ubuntu-latest`, publish test results and the WAR artifact, and build a Docker image. To enable SonarQube, install the SonarQube Azure DevOps extension, create a service connection named `SonarQube`, and run the pipeline with the `runSonarQube` parameter set to `true`.

The Docker image is built locally on the pipeline agent. It is not pushed to a registry. Add an authenticated registry push step if you need to publish it to Docker Hub, Azure Container Registry, or another registry.

## SonarQube settings

For Maven analysis, use the Maven scanner so it can discover the multi-module POM structure:

```bash
mvn --batch-mode --no-transfer-progress clean verify sonar:sonar -Dsonar.projectKey=SubuDemo
```

Set `SONAR_HOST_URL`/credentials using your CI server's secure SonarQube integration. The `sonar-project.properties` file is for the standalone SonarScanner CLI and is not required by the Maven scanner.
