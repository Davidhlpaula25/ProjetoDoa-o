# authentication

passo a passo

1-Criar Projeto no Firebase:

-Crie um projeto no Console do Firebase.

-Clique em "Authentication" e escolha o método que vai usar (Google). Ative.

-Selecione o email e salve.

2-Visão Geral do Projeto:

-Escolha Android. Vai pedir algumas informações, incluindo o Nome do Pacote do Android (applicationId), clique em registrar.

-No seu projeto, dentro da pasta android/app/build.gradle, pegue a informação do applicationId.

3-Configurações no Android:

-Faça download do arquivo google-services.json e coloque-o na pasta android/app do seu projeto Flutter, junto com build.gradle.

-No arquivo android/build.gradle, adicione o repositório do Firebase:
buildscript {
  dependencies {
    classpath 'com.google.gms:google-services:4.3.10'
  }
}
-No arquivo android/app/build.gradle, aplique o plugin:
apply plugin: 'com.google.gms.google-services'
4-Configuração de Certificado:

-No Firebase, em "Configurações do Projeto", configure o certificado para integração segura.

Adicione a chave SHA-1:
comando para ter acesso a chave:: keytool -list -v -keystore <path-to-debug-or-production-keystore> -alias <key-alias> -keypass <key-password> -storepass <keystore-password>

outro :: keytool -list -v -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore  que funciono no meu

5-Adicionar Dependências no Flutter:

-Execute no terminal:
flutter pub add firebase_auth
flutter pub add google_sign_in
flutter pub add firebase_core
flutter pub add flutterfire

6-Login com Google:

-No login_view.dart, adicione o botão para entrar com Google.

-Converta o main.dart para uma classe async.

-No login_controller.dart, adicione:

