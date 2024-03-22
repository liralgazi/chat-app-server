import express from 'express';
import { getAllMessages } from '../config/db';
const router = express.Router();


const app = express()


app.get('/', async (req,res)=>{
    try{
        const messages = getAllMessages()
        res.send(messages);
    }catch{}
});



export default router;