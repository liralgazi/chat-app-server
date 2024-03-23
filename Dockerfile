# Stage 1: Build the backend application from TypeScript to JavaScript
FROM node:16 as builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json (if available)
COPY package*.json ./

# Install dependencies, including 'devDependencies' for building
RUN npm install

# Copy the backend TypeScript source code into the Docker image
COPY . .

# Run the TypeScript compiler to build the JavaScript files
RUN npm run build

# Start a new, final stage to create a smaller production image
FROM node:16

# Set the working directory for the production image
WORKDIR /app

# Copy package.json and other necessary files
COPY package*.json ./

# Install only production dependencies in the final image
RUN npm install --only=production

# Copy the compiled JavaScript from the builder stage
COPY --from=builder /app/build ./build

# Copy frontend build artifacts into the public directory of the Docker container
# Adjust this line if your frontend artifacts are located in a different directory
COPY --from=builder /app/frontend-build ./public

# Expose the port the backend server listens on
EXPOSE 3002

# Command to run the backend server
CMD ["npm", "run", "start:prod"]
