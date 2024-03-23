# Use Node.js as base image
FROM node:14-alpine

# Set working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy all source code
COPY . .

# Build TypeScript code
RUN npm run build

# Expose the port on which the server will run
EXPOSE 3002

# Command to run the server
CMD ["npm", "start"]
