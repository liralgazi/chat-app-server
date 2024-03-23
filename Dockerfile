# Stage 1: Clone the frontend project
FROM alpine/git AS frontend-clone
WORKDIR /app/frontend
RUN git clone https://github.com/liralgazi/chat-app.git .

# Stage 2: Clone the backend project
FROM alpine/git AS backend-clone
WORKDIR /app/backend
RUN git clone https://github.com/liralgazi/chat-app-server.git .

# Stage 3: Build the backend
FROM node:16 AS backend-build
WORKDIR /app/backend
COPY --from=backend-clone /app/backend /app/backend
RUN npm install
RUN npm run build

# Stage 4: Copy built backend files and frontend files
FROM node:16 AS final
WORKDIR /app
COPY --from=backend-build /app/backend/dist /app/backend
COPY --from=frontend-clone /app/frontend /app/frontend

# Expose the necessary ports and run the backend
EXPOSE 3002
CMD ["node", "/app/backend/index.js"]
