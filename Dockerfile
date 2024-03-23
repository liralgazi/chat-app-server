# Base image for Node
FROM node:16 as builder

# Set working directory for the build stage
WORKDIR /app

# Assuming you've handled the frontend build process separately,
# as the frontend and backend are in different repositories.

# Copy the backend application and install its dependencies
COPY package*.json ./
RUN npm install

# Build the backend application
COPY . .
RUN npm run build

# Setup the final image
FROM node:16-slim

# Set working directory for the final image
WORKDIR /app

# Copy the built backend application from the builder stage
COPY --from=builder /app/build ./build

# Copy necessary environment configuration files
COPY .env .

# Install only production dependencies
COPY package*.json ./
RUN npm install --only=production

# Expose the backend port
EXPOSE 3002

# Command to run the backend
CMD ["node", "build/index.js"]
