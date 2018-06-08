FROM gradle:4.8.0-jdk8 as builder

WORKDIR /hypergraphql

COPY ./build.gradle .
COPY ./src ./src
USER root
RUN chown -R gradle /hypergraphql
USER gradle

RUN gradle clean build shadowJar 

RUN ls -l /hypergraphql/build/libs

FROM java:8-alpine

WORKDIR /root
COPY --from=builder /hypergraphql/build/libs/hypergraphql-1.3.3-exe.jar /root/hypergraphql.jar
COPY ./config.json /root/config.json
COPY ./schema.graphql /root/schema.graphql

EXPOSE 8080

CMD java \
    -Dexec.args="--config /root/config.json" \
    -jar /root/hypergraphql.jar
