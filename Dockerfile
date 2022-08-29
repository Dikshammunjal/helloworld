FROM maven:3.5-jdk-8

WORKDIR .

# copy the project files

COPY ./pom.xml ./pom.xml

# build all dependencies for offline use

# RUN mvn dependency:go-offline -B

# copy your other files

COPY ./src ./src


# build for release
#RUN mvn package

RUN mvn package -DskipTests

#RUN mvn clean 



# set the startup command to run your binary

#ARG JAR_FILE=target/*.jar

RUN ls -ltr 

COPY target/*.jar app.jar

RUN ls -ltr 

EXPOSE 8080

ENTRYPOINT ["java","-jar","/app.jar"]


# ENTRYPOINT ["java","-jar","/target/myproject-0.0.1-SNAPSHOT.jar"]


# CMD ["sh", "target/bin/start"]



#FROM openjdk:8-jdk
#ADD ./target/myproject-0.0.1-SNAPSHOT.jar /myproject-0.0.1-SNAPSHOT.jar
#ADD ./run.sh /run.sh
#RUN chmod a+x /run.sh
#EXPOSE 8080:8080
#CMD /run.sh
