FROM adoptopenjdk/maven-openjdk11 as maven-builder
WORKDIR /tmp
COPY . ./
ENV MAVEN_OPTS="-Xmx1024m -XX:MaxPermSize=128m"
RUN mvn clean package -DskipTests=true
FROM adoptopenjdk/openjdk11
ENV JAR_FILE=target/DiscoveryServer*.jar
COPY --from=maven-builder /tmp/$JAR_FILE /opt/app/
RUN mv /opt/app/DiscoveryServer-*.jar /opt/app/app.jar
WORKDIR /opt/app
ENV PORT 8761
EXPOSE 8761
ENTRYPOINT ["java","-jar","app.jar"]