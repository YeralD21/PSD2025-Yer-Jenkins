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
                    // Descargar e instalar Flutter (puedes ajustar la versión si es necesario)
                    sh 'git clone https://github.com/flutter/flutter.git -b stable'
                    sh 'export PATH="$PATH:`pwd`/flutter/bin"'
                    sh 'flutter precache' // Descargar los artefactos necesarios para el SDK
                }
            }
        }
        stage('Build') {
            steps {
                timeout(time: 8, unit: 'MINUTES'){
                    // Navegar al directorio del proyecto Flutter y obtener dependencias
                    dir('capachica-app') { // Asume que 'capachica-app' es el subdirectorio de tu proyecto Flutter
                        sh 'export PATH="$PATH:`pwd`/../flutter/bin"' // Asegúrate de que Flutter esté en el PATH
                        sh 'flutter pub get'
                        sh 'flutter build apk --release' // O 'flutter build ios --release' si es para iOS
                    }
                }
            }
        }
        stage('Test') {
            steps {
                timeout(time: 10, unit: 'MINUTES'){
                    dir('capachica-app') {
                        sh 'export PATH="$PATH:`pwd`/../flutter/bin"'
                        sh 'flutter test'
                    }
                }
            }
        }
        stage('Sonar') {
            steps {
                timeout(time: 4, unit: 'MINUTES'){
                    withSonarQubeEnv('sonarqube'){
                        dir('capachica-app') {
                            // Este comando puede necesitar ajustes dependiendo de cómo integres SonarQube con Flutter.
                            // Por ejemplo, podrías usar un analizador de SonarCloud para Dart/Flutter.
                            sh 'sonar-scanner \
                                -Dsonar.projectKey=capachica-app \
                                -Dsonar.sources=lib \
                                -Dsonar.host.url=$SONAR_HOST_URL \
                                -Dsonar.login=$SONAR_AUTH_TOKEN'
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
                        echo "flutter build appbundle --release" // Para subir a Google Play Store
                        echo "flutter build ipa --release" // Para subir a Apple App Store (requiere macOS)
                        // O si despliegas a un servidor:
                        // echo "scp build/app/outputs/flutter-apk/app-release.apk user@your-server:/path/to/deploy"
                    }
                }           
            }
        }
    }
}