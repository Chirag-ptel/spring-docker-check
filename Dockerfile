FROM maven:latest
WORKDIR /app
COPY pom.xml .
COPY src src
RUN mvn clean package
# FROM openjdk:18
WORKDIR /app
ARG JAR_FILE=/target/spring-boot-2-rest-service-basic-0.0.1-SNAPSHOT.jar
ADD ${JAR_FILE} app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app.jar"]