const express = require('express');
const bcrypt = require('bcryptjs');
const dbClient = require('../database/database-connection');
const validator = require('validator');
const { user } = require('pg/lib/defaults');
const auth= require('../middleware/auth');
const jwt = require('jsonwebtoken');
const router = express.Router();

async function handleGetUserById(req, res) {
  const { user_id, password, email } = req.body;

  try {
    let user;
    if (email) {
      user = await dbClient.query('SELECT * FROM Users WHERE email = $1', [email]);
    } else {
      user = await dbClient.query('SELECT * FROM Users WHERE user_id = $1', [user_id]);
    }

    if (user.rows.length === 0) return res.status(400).send('User not found');

    const validPass = await bcrypt.compare(password, user.rows[0].password);
    if (!validPass) return res.status(400).send('Invalid password');

    const token = "sahil"
    res.status(200).header('Authorization', `Bearer ${token}`).send({
      token,
      user: {
        user_id: user.rows[0].user_id,
        email: user.rows[0].email,
      }
    });
  } catch (error) {
    res.status(400).send(error.message);
  }
}


async function handleDevice(req, res) {
  const { user_id, device_id, type } = req.body;

  const allowedDeviceTypes = ['iphone', 'android', 'website', 'macbook', 'windows'];

  console.log('Request body:', req.body);

  try {
    if (!user_id || !device_id || !type) {
      return res.status(400).json({ message: 'Missing required fields' });
    }

    const currentTimestamp = new Date().toISOString();

    if (!allowedDeviceTypes.includes(type)) {
      return res.status(400).json({ message: `Login from ${type} is not allowed` });
    }

    const userDevices = await dbClient.query('SELECT * FROM devices WHERE user_id = $1', [user_id]);
    console.log('User devices:', userDevices.rows);

    const activeDeviceOfType = userDevices.rows.find(device => device.type === type && device.isactive === true);
    const activePhoneDevice = userDevices.rows.find(device => (device.type === 'iphone' || device.type === 'android') && device.isactive === true);
    const activeLaptopDevice = userDevices.rows.find(device => (device.type === 'macbook' || device.type === 'windows') && device.isactive === true);

    if (activeDeviceOfType) {
      return res.status(500).json({ message: "User already logged in on a device of this type", user: activeDeviceOfType });
    } else if (activePhoneDevice && (type === 'iphone' || type === 'android')) {
      return res.status(500).json({ message: "User already logged in on a different phone type", user: activePhoneDevice });
    } else if (activeLaptopDevice && (type === 'macbook' || type === 'windows')) {
      return res.status(500).json({ message: "User already logged in on a different laptop type", user: activeLaptopDevice });
    }

    const existingDevice = userDevices.rows.find(device => device.device_id === device_id);

    if (existingDevice) {
      await dbClient.query(
        'UPDATE devices SET isactive = true, updated_at = $1 WHERE user_id = $2 AND device_id = $3 AND type = $4', 
        [currentTimestamp, user_id, device_id, type]
      );
      console.log('Device reactivated:', existingDevice);
      return res.status(200).json({ message: "Device reactivated successfully" });
    } else {
      const newDevice = await dbClient.query(
        `INSERT INTO devices (user_id, device_id, type, isactive, created_at, updated_at) 
         VALUES ($1, $2, $3, true, $4, $4) RETURNING *`,
        [user_id, device_id, type, currentTimestamp]
      );
      console.log('New device registered:', newDevice.rows[0]);
      return res.status(200).json({ message: "Device registered and activated successfully" });
    }
  } catch (error) {
    console.error('Error in handleDevice:', error);
    res.status(400).send(error.message || 'An error occurred');
  }
}



async function handleAddNewUser(req, res) {
  const { user_id, email, password } = req.body;

  console.log(user_id);

  if (!user_id || !email || !password) {
    return res.status(400).json({ error: 'Missing required fields' });
  }

  const hashedPassword = await bcrypt.hash(password, 10);
  const currentTimestamp = new Date();

  try {
    const result = await dbClient.query(
      `INSERT INTO Users (user_id, email, password, created_at, updated_at) 
       VALUES ($1, $2, $3, $4, $4) RETURNING *`,
      [user_id, email, hashedPassword, currentTimestamp]
    );
    res.status(201).json({ message: 'User created successfully', user: result.rows[0] });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: error.message });
  }
}

module.exports = {
  handleGetUserById,
  handleDevice,
  handleAddNewUser
};
