const express = require('express');
const http = require('http');
const path = require('path');
const userRouter = require('./routes/user');
const dbClient = require('./database/database-connection'); // Import the database client
const setupSocket = require('./sockets/socket'); // Import the socket setup
const profileRouter = require('./routes/profile');
const app = express();
app.use(express.json()); 
app.use('/uploads/profile', express.static(path.join(__dirname,'uploads/profile')));
app.use(express.urlencoded({ extended: false }));
app.use('/', userRouter);
app.use('/profile', profileRouter);
const server = http.createServer(app); 
setupSocket(server); // Initialize the socket setup

server.listen(3000, () => {
  console.log('listening on *:3000');
}); 
