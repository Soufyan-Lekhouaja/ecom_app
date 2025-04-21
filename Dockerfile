FROM openjdk:17-jdk-slim

# Installer Maven et autres dépendances nécessaires
RUN apt-get update && \
    apt-get install -y maven && \
    apt-get clean

# Définir le répertoire de travail
WORKDIR /app

# Copier le contenu du projet dans le conteneur
COPY . /app

# Construire l'application avec Maven
RUN mvn clean install

# Exposer le port sur lequel l'application va tourner
EXPOSE 8083

# Démarrer l'application
CMD ["java", "-jar", "target/ecomapp.jar", "--server.port=8083"]
