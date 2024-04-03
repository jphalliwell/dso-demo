FROM maven:3.9.6-eclipse-temurin-17-alpine

WORKDIR /app

COPY .  .

RUN mvn package -DskipTests && \
    mv target/demo-0.0.1-SNAPSHOT.jar /run/demo.jar

EXPOSE 8080

CMD java  -jar /run/demo.jar
