# Use an official Node.js runtime as a parent image
FROM node:16 as builder

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json (if available) to the container
COPY package*.json ./

# Install any dependencies, including 'devDependencies' needed for building
RUN npm install

# Copy your TypeScript source code into the Docker image
COPY . .

# Compile TypeScript to JavaScript
RUN npm run build

# Start a new stage to create a smaller image for production
FROM node:16

WORKDIR /app

# Copy package.json and other necessary files
COPY package*.json ./

# Install only production dependencies
RUN npm install --only=production

# Copy the compiled JavaScript from the previous stage
COPY --from=builder /app/build ./build

# Copy frontend build artifacts into the public directory
COPY --from=builder /app/frontend-build ./public

# Expose your application's default port
EXPOSE 3002

# Use the 'start:prod' script to run your compiled application
CMD ["npm", "run", "start:prod"]
