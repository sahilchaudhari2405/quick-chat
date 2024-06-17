const http = require('http');
const express = require('express');
const socketIo = require('socket.io');
const redis = require('redis');

const app = express();
const server = http.createServer(app); 
const io = socketIo(server);

const redisClient = redis.createClient();
const redisPublisher = redisClient.duplicate();
const redisSubscriber = redisClient.duplicate();

let client = {};

redisClient.on('error', (err) => console.error('Redis Client Error', err));
redisPublisher.on('error', (err) => console.error('Redis Publisher Error', err));
redisSubscriber.on('error', (err) => console.error('Redis Subscriber Error', err));

(async () => {
  await redisClient.connect();
  await redisPublisher.connect();
  await redisSubscriber.connect();

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

  await redisSubscriber.subscribe('messages');
})();

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
    let targetId = msg.targetId;
    if (client[targetId]) {
      client[targetId].emit("message", msg);
    } else {
      try {
        await redisPublisher.publish('messages', JSON.stringify(msg));
      } catch (err) {
        console.error("Error publishing message:", err);
      }
    }
  });
});

server.listen(9000, () => {
  console.log('listening on 9000')});
