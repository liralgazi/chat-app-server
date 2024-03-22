export interface Message {
    id: number;
    text: string;
    sender: string;
    timestamp: Date; 
  }
  
  export type NewMessage = Omit<Message, 'id'>; 