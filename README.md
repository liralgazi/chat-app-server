# Chat App Server

This is the backend server for the Chat App project. It's built using Node.js, TypeScript, and PostgreSQL.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Setup](#setup)
- [Usage](#usage)
- [Endpoints](#endpoints)
- [Dependencies](#dependencies)
- [License](#license)

## Introduction

The Chat App Server provides the backend functionality for a real-time chat application. It handles user authentication, message storage, and message retrieval.

## Features

- Real-time messaging using Socket.IO
- User authentication
- Message storage in a PostgreSQL database
- Pagination for fetching messages

## Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/liralgazi/chat-app-server.git

   ```

2. Install dependencies:

```bash
 cd chat-app-server
 npm install
```

4. Set up environment variables:
   Create a .env file in the root directory and add the following variables:
   PORT=3002
   PG_URL=postgres://username:password@localhost:5432/chat-app
5. Run the server:
   ```bash
   npm start
   ```

## usage

Once the server is running, you can connect to it using the frontend application. Make sure the frontend is configured to communicate with this server.

## Endpoints

- [GET /api/messages: Fetches messages from the database. Supports pagination with query parameters limit and offset.]
- [Dependencies]
- [Express.js: Web framework for Node.js]
- [Socket.IO: Real-time bidirectional event-based communication library]
- [PostgreSQL: Database system for storing messages]
- [Sequelize: ORM for interacting with the PostgreSQL database]
- [dotenv: Loads environment variables from a .env file]
- [cors: Middleware for handling Cross-Origin Resource Sharing (CORS)]

## License

This project is licensed under the ISC License.
