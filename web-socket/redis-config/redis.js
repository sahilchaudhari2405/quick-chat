const Redis = require('ioredis');

// Initialize the main Redis client
const redisClient = new Redis({
  host: 'localhost',
  port: 6379,
  // password: 'your_redis_password',  // Uncomment if authentication is required
});

// Duplicate the client for publishing messages
const redisPublisher = redisClient.duplicate();

// Duplicate the client for subscribing to messages
const redisSubscriber = redisClient.duplicate();

// Error handling for Redis clients
redisClient.on('error', (err) => console.error('Redis Client Error', err));
redisPublisher.on('error', (err) => console.error('Redis Publisher Error', err));
redisSubscriber.on('error', (err) => console.error('Redis Subscriber Error', err));

// Export the configured clients
module.exports = {
  redisClient,
  redisPublisher,
  redisSubscriber
};
