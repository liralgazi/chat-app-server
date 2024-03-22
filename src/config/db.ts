import pg from 'pg';
import { Message } from '../models/MessageModel';
import dotenv from 'dotenv';
dotenv.config();


const client = new pg.Client({
    connectionString: process.env.PG_URL,
    //connectionString: "postgres://postgres:la1234@localhost:5432/chat-app"
  });

// Wrap the connection setup in an asynchronous function
const connectToDatabase = async () => {
  try {
      await client.connect();
      console.log('Connected to PostgreSQL');
  } catch (error) {
      console.error('Error connecting to PostgreSQL:', error);
  }
};

connectToDatabase();

export const saveMessage = async (message: Message) => {
  // Using queryConfig for clearer structure
  const queryConfig = {
    text: `INSERT INTO messages(text, sender, timestamp) VALUES ($1, $2, $3) RETURNING *;`,
    values: [message.text, message.sender, new Date()] as any[],
  };

  try {
    const res = await client.query(queryConfig);
    console.log(res.rows[0]); // Logging the inserted message
  } catch (err) {
    console.error('Error saving message:', err);
  }
}
export const getAllMessages = async () => {
    const query = `SELECT * FROM messages ORDER BY timestamp DESC;`;
    try {
        const res = await client.query(query);
        return res.rows;
    } catch (err) {
        console.error(err);
        return [];
    }
};

// get chunk of messages if needed - through scrolling 
export const getPageOfMessages = async (limit: number, offset: number) => {
    const query = `SELECT * FROM messages ORDER BY timestamp DESC LIMIT $1 OFFSET $2;`;
    try {
      const res = await client.query(query, [limit, offset]);
      console.log("20")

      return res.rows;
    } catch (err) {
      console.error(err);
      return [];
    }
  };

