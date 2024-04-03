FROM maven:3.8.7-openjdk-18-slim AS build
WORKDIR /app
COPY . .
RUN mvn package -DskipTests



FROM openjdk:18-alpine AS run
COPY --from=build /app/target/demo-0.0.1-SNAPSHOT.jar /run/demo.jar

ARG USER=devops
ENV HOME /home/$USER
RUN adduser -D $USER && \
    chown $USER:$USER /run/demo.jar

RUN apk add --no-cache curl
# adding upgraded packages to pass trivy
RUN apk upgrade zlib libtasn1 ssl_client  busybox libcrypto1.1 libretls libssl1.1
HEALTHCHECK --interval=30s --timeout=10s --retries=2 --start-period=20s \
    CMD curl -f http://localhost:8080/ || exit 1

USER $USER
EXPOSE 8080
CMD java -jar /run/demo.jar
