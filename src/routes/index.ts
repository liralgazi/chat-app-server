import express from 'express';
import { getAllMessages } from '../config/db';

const router = express.Router();

router.get('/messages', async (req, res) => {
    try{
        const messages = await getAllMessages()
        res.send(messages);        
    }catch(err){
        console.log(err)
    }
});


export default router;