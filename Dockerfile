# Stage 1: Clone and build the frontend
FROM node:16 AS frontend-build
WORKDIR /app/frontend

# Clone your frontend repository
RUN git clone https://github.com/liralgazi/chat-app.git .

# Install dependencies and build the project
RUN npm install
RUN npm run build

# Stage 2: Clone and setup the backend
FROM node:16 AS backend-setup
WORKDIR /app/backend

# Clone your backend repository
RUN git clone https://github.com/liralgazi/chat-app-server.git .

# Ensure NODE_ENV is not set to production to include devDependencies
ENV NODE_ENV=development

# Copy the tsconfig.json file to the Docker container
COPY tsconfig.json /app/backend/tsconfig.json

# Install backend dependencies, including devDependencies
RUN npm install

# Set executable permissions for all scripts in node_modules/.bin
RUN chmod +x -R node_modules/.bin

# Build the backend TypeScript files to JavaScript
RUN ./node_modules/.bin/tsc

# Copy built frontend files from the frontend-build stage to the backend's public directory
COPY --from=frontend-build /app/frontend/dist /app/backend/public

# Expose the backend port
EXPOSE 3002

# Use the production start script
CMD ["npm", "run", "start:prod"]
