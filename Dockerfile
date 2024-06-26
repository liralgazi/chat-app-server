# Use Node.js as base image
FROM node:14 AS builder

# Set working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies and set execute permission for nodemon
RUN npm install

# Copy all source code
COPY . .

# Build TypeScript code
RUN npm run build

# Expose the port on which the server will run
EXPOSE 3002

# Command to run the server
CMD ["npm", "start","start:backend"]
