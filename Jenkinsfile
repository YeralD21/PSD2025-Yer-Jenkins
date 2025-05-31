pipeline {
    agent any

    stages {
        stage('Clone') {
            steps {
                timeout(time: 2, unit: 'MINUTES'){
                    git branch: 'main', credentialsId: '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', url: 'https://github.com/YeralD21/PSD2025-Yer-Jenkins.git'
                }
            }
        }
        stage('Setup Flutter') {
            steps {
                timeout(time: 5, unit: 'MINUTES'){
                    sh '/opt/flutter/bin/flutter --version'
					sh '/opt/flutter/bin/flutter precache'
                }
            }
        }
        stage('Build') {
            steps {
                timeout(time: 20, unit: 'MINUTES'){
                    dir('capachica-app') {
                        sh 'export PATH="$PATH:`pwd`/../flutter/bin"'
                        sh '/opt/flutter/bin/flutter pub get'
						sh '/opt/flutter/bin/flutter build apk --release'
                    }
                }
            }
        }
        stage('Test & Coverage') {
            steps {
                timeout(time: 10, unit: 'MINUTES'){
                    dir('capachica-app') {
                        sh 'export PATH="$PATH:`pwd`/../flutter/bin"'
                        // Ejecuta los tests y genera el reporte de cobertura
                        sh 'flutter test --coverage'
                    }
                }
            }
        }
        stage('Sonar') {
            steps {
                timeout(time: 10, unit: 'MINUTES'){
                    withSonarQubeEnv('sonarqube'){
                        dir('capachica-app') {
                            // Ejecuta el análisis SonarQube incluyendo el reporte de cobertura
                            sh 'sonar-scanner'
                        }
                    }
                }
            }
        }
        stage('Quality gate') {
            steps {
                sleep(10) //seconds
                timeout(time: 4, unit: 'MINUTES'){
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage('Deploy') {
            steps {
                timeout(time: 8, unit: 'MINUTES'){
                    dir('capachica-app') {
                        sh 'export PATH="$PATH:`pwd`/../flutter/bin"'
                        echo "Aquí iría el comando para desplegar tu aplicación Flutter. Por ejemplo:"
                        echo "flutter build appbundle --release"
                        echo "flutter build ipa --release"
                        // O si despliegas a un servidor:
                        // echo "scp build/app/outputs/flutter-apk/app-release.apk user@your-server:/path/to/deploy"
                    }
                }           
            }
        }
    }
}