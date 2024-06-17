const express = require('express');

const path = require('path');
const userRouter = require('./routes/user');
const dbClient = require('./database/database-connection'); // Import the database client
const profileRouter = require('./routes/profile');
const OhterUser=require('./routes/NewUserConnect');
const app = express();
app.use(express.json()); 
app.use('/uploads/profile', express.static(path.join(__dirname,'uploads/profile')));
app.use(express.urlencoded({ extended: false }));
app.use('/', userRouter);
app.use('/profile', profileRouter);
app.use('/user',OhterUser);


 
app.listen(3000, () => {
  console.log('listening on *:3000');
}); 
