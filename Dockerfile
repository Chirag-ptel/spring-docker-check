FROM --platform=linux/amd64 maven:latest
COPY pom.xml .
COPY src src
RUN mvn clean package
FROM --platform=linux/amd64 openjdk:18
COPY ./target/spring-boot-2-rest-service-basic-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]