const express = require('express');
const router = express.Router();
const {handleAddNewUser,handleDevice,handleGetUserById} =require('../controller/user_auth')
router.route('/signup').post(handleAddNewUser)
router.route('/login').post(handleGetUserById);
router.route('/device').post(handleDevice);
module.exports = router;