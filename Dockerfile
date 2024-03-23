# Stage 1: Build the frontend
FROM node:16 as frontend-build

# Set working directory for the frontend build
WORKDIR /app/frontend

# Clone the frontend repository
RUN git clone https://github.com/liralgazi/chat-app.git .

# Install frontend dependencies and build static files
RUN npm install && npm run build

# Stage 2: Build the backend and include frontend static files
FROM node:16

# Set working directory for the backend
WORKDIR /app

# Clone the backend repository
RUN git clone https://github.com/liralgazi/chat-app-server.git .

# Install backend dependencies
RUN npm install

# Copy built static files from the frontend-build stage to the backend public directory
COPY --from=frontend-build /app/frontend/dist /app/public

# Expose the backend port
EXPOSE 3002

# Start the backend server, adjust the command based on your server start command
CMD ["npm", "start"]
