# ===== Build stage =====
FROM maven:3.8.7-eclipse-temurin-17 AS build
WORKDIR /app

# Copy file cấu hình trước để cache dependency
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code và build ra file WAR
COPY src ./src
RUN mvn clean package -DskipTests

# ===== Run stage =====
FROM tomcat:9.0-jdk17

# Xóa webapp mặc định (ROOT)
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy file WAR build ra thành ứng dụng chính
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose cổng 8080 (Render sẽ map port này)
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
