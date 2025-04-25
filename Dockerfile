FROM openjdk:17-jdk-slim


# Définir le répertoire de travail
WORKDIR /app

# Copier le contenu du projet dans le conteneur
COPY . .
# Construire l'application avec Maven
#RUN mvn clean install

# Exposer le port sur lequel l'application va tourner
EXPOSE 8083

# Démarrer l'application
CMD ["java", "-jar", "target/ecomapp.jar", "--server.port=8083"]
