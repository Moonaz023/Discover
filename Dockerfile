# Use a Maven image to build the project
FROM maven:3.8.3-openjdk-17 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml and the source code into the container
COPY pom.xml .
COPY src ./src

# Build the project
RUN mvn clean package -DskipTests

# Use a smaller Java runtime image for the final container
FROM  openjdk:17.0.1-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the jar file from the build stage into the final image
COPY --from=builder /app/target/DiscoveryService-0.0.1-SNAPSHOT.jar ./app.jar

# Expose the port on which the application will run
EXPOSE 8761

# Define the entry point for the container
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
