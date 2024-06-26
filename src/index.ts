import express from 'express';
import cors from 'cors';
import routes from './routes'; 
import http from 'http';
import { Server } from 'socket.io';
import { saveMessage, getAllMessages, getPageOfMessages } from './config/db'; 
import dotenv from 'dotenv';
import path from 'path'; 

const app = express();
dotenv.config();
const server = http.createServer(app);
const io = new Server(server, {});

app.use(express.json());

app.use(express.static(path.join(__dirname, '..', 'dist')));
/*
// Serve static files from "dist" directory for non-API routes
app.use(express.static("dist"));
*/
app.use('/api', routes);

// Configure CORS
const corsOptions = {
    origin: '*', 
    allowedHeaders: ['Content-Type'], 
};
app.use(cors(corsOptions));

// Path to the frontend build directory
const frontendBuildPath = path.join(__dirname, 'dist');
app.use(express.static(frontendBuildPath));

// Catch-all route for non-API routes to serve the index.html for SPA (Single Page Application) routing
// After
app.get('*', (req, res) => {
    res.sendFile(path.resolve(__dirname, '..', 'dist', 'index.html'));
  });
// Define the port to run the server on
const PORT = process.env.PORT || 3002;

// Start the server
server.listen(PORT, () => {
    console.log(`Server started on port ${PORT}`);
});

// WebSocket connection handling using Socket.IO
io.on('connection', async (socket) => {
    console.log('A user connected');

    // Handle 'message' events
    socket.on('message', async (message) => {
        await saveMessage(message); // Save the message to the database
        io.emit('message', message); // Broadcast the message to all connected clients
    });

    // Handle user disconnection
    socket.on('disconnect', () => {
        console.log('A user disconnected');
    });
});

// API route for fetching messages
app.get('/api/messages', async (req, res) => { 
    let messages;
  
    // Handle pagination parameters if present
    if (typeof req.query.limit === 'string' && typeof req.query.offset === 'string') {
        const limit = parseInt(req.query.limit) || 20;
        const offset = parseInt(req.query.offset) || 0;
  
        messages = await getPageOfMessages(limit, offset); // Fetch a page of messages
    } else {
        messages = await getAllMessages(); // Fetch all messages
    }
    res.json(messages);
});
