const express = require('express');
const router = express.Router();
const {handleRefreshToken} = require('../controller/refreshAccessToken');
const {handleLogout} = require('../controller/logout')
const {handleAddNewUser,handleDevice,handlelogin} =require('../controller/user_auth')
router.route('/signup').post(handleAddNewUser)
router.route('/login').post(handlelogin);
router.route('/device').post(handleDevice);
router.route('/logout').patch(handleLogout);
router.route('/refreshToken').post(handleRefreshToken);
module.exports = router;    