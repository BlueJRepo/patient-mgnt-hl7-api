#FROM openjdk:21 //Deprecated from Docker
FROM eclipse-temurin:21-jdk-alpine
WORKDIR /app
COPY ./target/*.jar /app
EXPOSE 8080
CMD ["java", "-jar", "patient-mgnt-hl7-api.jar"]