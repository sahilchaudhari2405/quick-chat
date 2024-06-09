const socketIo = require('socket.io');

const client = {};

const setupSocket = (server) => {
  const io = socketIo(server);

  io.on('connection', (socket) => {
    console.log('a user connected');

    socket.on('disconnect', () => {
      console.log('user disconnected');
    });

    socket.on('SignIn', (id) => {
      client[id] = socket;
      console.log(client);
    });

    socket.on('message', (msg) => {
      console.log(msg);
      let targetId = msg.targetId;
      if (client[targetId]) {
        client[targetId].emit("message", msg);
      }
    });
  });

  return io;
};

module.exports = setupSocket;
