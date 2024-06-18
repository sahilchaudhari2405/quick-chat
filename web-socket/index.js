const http = require('http');
const express = require('express');
const socketIo = require('socket.io');
const { redisClient, redisPublisher, redisSubscriber } = require('./redis-config/redis');

const app = express();
const server = http.createServer(app); 
const io = socketIo(server);

let client = {};

// Subscribe to Redis channel
redisSubscriber.subscribe('messages','messageWithdata', (err, count) => {
  if (err) {
    console.error('Failed to subscribe: ', err);
    return;
  }
  console.log(`Subscribed successfully! This client is currently subscribed to ${count} channels.`);
});

// Handle messages from Redis
redisSubscriber.on('message', (channel, message) => {
  if (channel === 'messages') {
    try {
      let parsedMessage = JSON.parse(message);
      let targetId = parsedMessage.targetId;
      if (client[targetId]) {
        client[targetId].emit("message", parsedMessage);
      }
    } catch (err) {
      console.error("Error parsing message:", err);
    }
  }
});
redisSubscriber.on('messageWithdata', (channel, message) => {
  if (channel === 'messageWithdata') {
    try {
      let parsedMessage = JSON.parse(message);
      let targetId = parsedMessage.targetId;
      if (client[targetId]) {
        client[targetId].emit("messageWithdata", parsedMessage);
      }
    } catch (err) {
      console.error("Error parsing message:", err);
    }
  }
});
// Handle socket connections
io.on('connection', (socket) => {
  console.log('a user connected');

  socket.on('disconnect', () => {
    console.log('user disconnected');
    for (let id in client) {
      if (client[id] === socket) {
        delete client[id];
        break;
      }
    }
  });

  socket.on('SignIn', (id) => {
    client[id] = socket;
    console.log(client);
  });

  socket.on('message', async (msg) => {
    console.log(msg);

      try {
        await redisPublisher.publish('messages', JSON.stringify(msg));
      } catch (err) {
        console.error("Error publishing message:", err);
      }
    }
  );
  socket.on('messageWithdata', async (msg) => {
    console.log(msg);

      try {
        await redisPublisher.publish('messageWithdata', JSON.stringify(msg));
      } catch (err) {
        console.error("Error publishing message:", err);
      }
    }
  );
});

server.listen(9000, () => {
  console.log('listening on 9000');
});
