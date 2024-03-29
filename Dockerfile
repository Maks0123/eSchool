FROM maven:3.5.2-jdk-8-alpine AS MAVEN_TOOL_CHAIN
COPY pom.xml /tmp/
COPY src /tmp/src/
WORKDIR /tmp/

RUN mvn clean
RUN mvn package -DskipTests

FROM openjdk:8-jdk-alpine
WORKDIR /usr/src/app
COPY --from=MAVEN_TOOL_CHAIN /tmp/target/eschool.jar eschool.jar
RUN adduser -D node && chown -R node /usr/src/app
USER node
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "eschool.jar"]
