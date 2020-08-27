FROM quintoandar/docker-jdk-gradle:jdk11-2019-02-10_1

WORKDIR /application

COPY . .

RUN pwd

RUN ./gradlew build -x test

RUN pwd

RUN ls /application/

FROM openjdk:11.0.7-jdk

ARG VERSION
ARG DATADOG_VERSION="0.49.0"
ENV APP_VERSION="1.0.0"

LABEL maintainer="Guiabolso Team"

RUN mkdir -p /opt/app/libs

RUN wget -O /opt/app/libs/dd-java-agent.jar "https://repository.sonatype.org/service/local/artifact/maven/redirect?r=central-proxy&g=com.datadoghq&a=dd-java-agent&v=$DATADOG_VERSION"

# ADD "application/build/distributions/application-${APP_VERSION}.tar" /opt/app/
COPY --from=0 /application/build/distributions/application-${APP_VERSION}.tar /opt/app/

EXPOSE 8080
CMD "/opt/app/application-${APP_VERSION}/bin/application"
