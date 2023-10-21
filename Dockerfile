# Use the official Golang image to create a build artifact.
# This is based on Debian and sets the GOPATH to /go.
FROM golang:latest as builder

ARG TARGETOS
ARG TARGETARCH

# Create and change to the app directory.
WORKDIR /app

# Retrieve application dependencies using go modules.
# Allows container builds to reuse downloaded dependencies.
COPY go.* ./
RUN go mod download

# Copy local code to the container image.
COPY . ./

#  Build the binary.
# -mod=readonly ensures immutable go.mod and go.sum in container builds.
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -mod=readonly -v -o server

# Use the official Alpine image for a lean production container.
# https://hub.docker.com/_/alpine
# https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
FROM alpine:3
RUN apk add --no-cache ca-certificates

# Copy the binary to the production image from the builder stage.
COPY --from=builder /app/server /server

# Run the web service on container startup.
CMD ["/server"]





# FROM maven:latest AS build
# # FROM --platform=linux/amd64 maven:latest AS build
# COPY pom.xml ./
# COPY src ./src
# RUN mkdir ./target
# RUN mvn -f ./pom.xml package
# # ARG JAR_FILE=target/spring-boot-2-rest-service-basic-0.0.1-SNAPSHOT.jar
# # ADD ${JAR_FILE} app.jar
# FROM openjdk:18
# COPY --from=build  ./target/spring-boot-2-rest-service-basic-0.0.1-SNAPSHOT.jar app.jar
# EXPOSE 8080
# ENTRYPOINT ["java","-jar","app.jar"]


# docker build -t sample-springboot-image:latest . && 
# docker tag sample-springboot-image:latest public.ecr.aws/t7b4x5g4/sample-ecr-spbt:latest && 
# aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/t7b4x5g4 && 
# docker push public.ecr.aws/t7b4x5g4/sample-ecr-spbt:latest
