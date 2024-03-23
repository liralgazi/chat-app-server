# Stage 1: Build the frontend
FROM node:16 as frontend-build
WORKDIR /app

# Your frontend Dockerfile here

# Stage 2: Prepare the backend
FROM node:16 as backend-setup
WORKDIR /backend

# Clone the backend repository and install dependencies
RUN git clone https://github.com/liralgazi/chat-app-server.git .
RUN npm install

# Stage 3: Setup the production environment
FROM node:16
WORKDIR /app

# Copy the backend setup (including node_modules)
COPY --from=backend-setup /backend ./backend

# Copy the frontend build output
COPY --from=frontend-build /app/build ./public

# Expose the backend port
EXPOSE 3002

# Start the backend server
CMD ["npm", "start"]
