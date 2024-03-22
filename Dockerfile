# Use an official Node runtime as a parent image for cloning and building
FROM node:16 AS clone-stage

# Install Git
RUN apt-get update && apt-get install -y git

# Clone the chat-app (frontend) repository
WORKDIR /app
RUN git clone https://github.com/liralgazi/chat-app.git

# Clone the chat-app-server (backend) repository
RUN git clone https://github.com/liralgazi/chat-app-server.git

# Build the chat-app (frontend)
WORKDIR /app/chat-app
RUN npm install
RUN npm run build

# Build the chat-app-server (backend)
WORKDIR /app/chat-app-server
RUN npm install
# If you're using TypeScript, compile your project. Adjust this command according to your project's setup.
# RUN npm run 

# Production image, copy all the files and run the server
FROM node:16
WORKDIR /app
COPY --from=clone-stage /app/chat-app-server .
# Copy built static files from chat-app build to the public directory of chat-app-server
# Adjust the paths according to where your server expects to serve static files from
COPY --from=clone-stage /app/chat-app/dist /app/public

EXPOSE 3002
CMD ["npm", "start"]
