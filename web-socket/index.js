const http = require('http');
const express = require('express');
const socketIo = require('socket.io');
const { redisClient, redisPublisher, redisSubscriber } = require('./redis-config/redis');

const app = express();
const server = http.createServer(app); 
const io = socketIo(server);

let clients = {};

// Subscribe to Redis channels
redisSubscriber.subscribe('messages', 'messageWithData', (err, count) => {
  if (err) {
    console.error('Failed to subscribe: ', err);
    return;
  }
  console.log(`Subscribed successfully! This client is currently subscribed to ${count} channels.`);
});

redisSubscriber.on('message', (channel, message) => {
  if (channel === 'messages') {
    try {
      let parsedMessage = JSON.parse(message);
      let targetId = parsedMessage.targetId;
      if (clients[targetId]) {
        clients[targetId].emit("message", parsedMessage);
      }
    } catch (err) {
      console.error("Error parsing message:", err);
    }
  }
});

redisSubscriber.on('message', (channel, message) => {
  if (channel === 'messageWithData') {
    console.log(message);
    try {
      let parsedMessage = JSON.parse(message);
      let targetId = parsedMessage.targetId;
      if (clients[targetId]) {
        clients[targetId].emit("messageWithData", parsedMessage);
      }
    } catch (err) {
      console.error("Error parsing message:", err);
    }
  }
});

io.on('connection', (socket) => {
  console.log('a user connected');

  socket.on('disconnect', () => {
    console.log('user disconnected');
    for (let id in clients) {
      if (clients[id] === socket) {
        delete clients[id];
        break;
      }
    }
  });

  socket.on('SignIn', (id) => {
    clients[id] = socket;
    console.log(clients);
  });

  socket.on('message', async (msg) => {
    console.log(msg);
    try {
      await redisPublisher.publish('messages', JSON.stringify(msg));
    } catch (err) {
      console.error("Error publishing message:", err);
    }
  });

  socket.on('messageWithData', async (msg) => {
    try {
      await redisPublisher.publish('messageWithData', JSON.stringify(msg));
    } catch (err) {
      console.error("Error publishing message:", err);
    }
  });
});

server.listen(9000, () => {
  console.log('listening on 9000');
});
