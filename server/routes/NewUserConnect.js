const express = require('express');
const router = express.Router();
const {AddNewContact}=require('../controller/AddContact');
const {handleFindUser}= require('../controller/findUser');
router.route('/search').get(handleFindUser);
router.route('/contacts').post(AddNewContact);
module.exports =router;