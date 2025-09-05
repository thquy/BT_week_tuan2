# ===== Build stage =====
FROM maven:3.8.7-eclipse-temurin-17 AS build
WORKDIR /app

# Copy pom.xml trước để cache dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build ra file WAR
RUN mvn clean package -DskipTests

# ===== Run stage =====
FROM tomcat:9.0-jdk17
WORKDIR /usr/local/tomcat

# Xóa ROOT mặc định
RUN rm -rf webapps/ROOT

# Copy WAR build ra làm ROOT.war
COPY --from=build /app/target/*.war webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
