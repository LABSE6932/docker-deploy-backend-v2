# Build stage: use Maven with Java 21 to compile the app
FROM maven:3.9-eclipse-temurin-21 AS build

# Set working directory inside the build container
WORKDIR /app

# Copy Maven project file to resolve dependencies
COPY pom.xml .

# Copy source code into the container
COPY src ./src

# Package the app into a JAR, skipping tests for faster builds
RUN mvn package -DskipTests


# Runtime stage: use a lightweight JRE-only image
FROM eclipse-temurin:21-jre

# Set working directory for the runtime container
WORKDIR /app

# Copy only the built JAR from the build stage (keeps image small)
COPY --from=build /app/target/backend.jar app.jar

# Expose port 8080 for incoming traffic
EXPOSE 8080

# Run the JAR when the container starts
ENTRYPOINT ["java", "-jar", "app.jar"]