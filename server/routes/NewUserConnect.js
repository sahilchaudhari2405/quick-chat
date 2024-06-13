const express = require('express');
const router = express.Router();
const {handleFindUser}= require('../controller/findUser');
router.route('/search/:id').get(handleFindUser);
module.exports =router;