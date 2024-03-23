import express from 'express';
import cors from 'cors';
import routes from './routes'; 
import http from 'http';
import { Server } from 'socket.io';
import { saveMessage, getAllMessages, getPageOfMessages } from './config/db'; 
import dotenv from 'dotenv';
import path from 'path'; // Import path module for handling file paths

const app = express();
dotenv.config();
const server = http.createServer(app);
const io = new Server(server, {});

app.use(express.json());

// Serve static files from "build/public/build" for non-API routes
app.use(express.static("dist"));

// ******************* //
// API routes from here

app.use('/api', routes);

// ******************* //

// Catch-all route for non-API routes
app.all(/^(?!\/api).*/, (req, res) => {
  res.sendFile(path.resolve(__dirname, "dist", "index.html"));
});




const corsOptions = {
    origin: '*', 
    allowedHeaders: ['Content-Type'], 
};

app.use(cors(corsOptions));

const frontendBuildPath = path.join(__dirname, 'public');
app.use(express.static(frontendBuildPath));

app.get('*', (req, res) => {
    res.sendFile(path.join(frontendBuildPath, 'index.html'));
});

const PORT = process.env.PORT || 3002;

server.listen(PORT, () => {
    console.log(`Server started on port ${PORT}`);
});

io.on('connection', async (socket) => {
    console.log('A user connected');

    socket.on('message', async (message) => {
        await saveMessage(message);
        io.emit('message', message);
    });

    socket.on('disconnect', () => {
        console.log('A user disconnected');
    });
});

app.get('/api/messages', async (req, res) => { 
    let messages;
  
    if (typeof req.query.limit === 'string' && typeof req.query.offset === 'string') {
        const limit = parseInt(req.query.limit) || 20;
        const offset = parseInt(req.query.offset) || 0;
  
        messages = await getPageOfMessages(limit, offset);
    } else {
        messages = await getAllMessages();
    }
    res.json(messages);
});
