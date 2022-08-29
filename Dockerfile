FROM maven:3.5-jdk-8

WORKDIR .

ADD ./target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","/app.jar"]

