pipeline {
  agent any

  tools {
    jdk 'JDK17'
    maven 'Maven3'
  }

  options {
    timestamps()
    disableConcurrentBuilds()
  }

  environment {
    IMAGE_NAME = 'hello-world-webapp'
  }


  stages {
    stage('Clean, Compile, Test, Package') {
      steps {
        sh 'mvn --batch-mode --no-transfer-progress clean verify'
      }
    }

    stage('SonarQube Analysis') {
      when { expression { return params.RUN_SONAR == true } }
      steps {
        withSonarQubeEnv('SonarQube') {
          sh 'mvn --batch-mode --no-transfer-progress sonar:sonar -Dsonar.projectKey=SubuDemo'
        }
      }
    }

    stage('Archive WAR') {
      steps {
        archiveArtifacts artifacts: 'webapp/target/webapp.war', fingerprint: true
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} .'
      }
    }
  }

  post {
    always {
      junit testResults: '**/target/surefire-reports/TEST-*.xml', allowEmptyResults: true
    }
  }

}
