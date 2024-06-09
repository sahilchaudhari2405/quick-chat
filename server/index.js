const express = require('express');
const http = require('http');
const userRouter = require('./routes/user');
const dbClient = require('./database/database-connection'); // Import the database client
const setupSocket = require('./sockets/socket'); // Import the socket setup

const app = express();
app.use(express.json()); 

app.use(express.urlencoded({ extended: false }));

app.use('/', userRouter);

const server = http.createServer(app);
setupSocket(server); // Initialize the socket setup

server.listen(3000, () => {
  console.log('listening on *:3000');
});
