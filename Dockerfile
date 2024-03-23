# Use Node.js 16 as the base image
FROM node:16

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the entire backend directory to the container
COPY . .

# Build the TypeScript files
RUN npm run build

# Expose the port that the Express server will run on
EXPOSE 3002

# Command to run the compiled JavaScript file
CMD ["node", "build/index.js"]
