FROM openjdk:17-jdk-slim
# Définir le répertoire de travail dans le conteneur
WORKDIR /app
# Copier le contenu du répertoire courant dans le conteneur
COPY . /app
RUN mvn clean install
# Exposer le port 8083 pour l'application
EXPOSE 8083
CMD ["java", "-jar", "target/ecomapp.jar", "--server.port=8083"]
