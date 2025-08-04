FROM openjdk:11-jre-slim

WORKDIR /app

# Copy the JAR file
COPY target/*.jar app.jar

# Expose the port
EXPOSE 8086

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"] 