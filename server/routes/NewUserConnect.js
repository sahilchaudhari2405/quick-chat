const express = require('express');
const router = express.Router();
const {AddNewContact}=require('../controller/AddContact');
const {handleFindUser}= require('../controller/findUser');
const {handleOtherGetUsers}=require('../controller/getOtherUser')
router.route('/search').get(handleFindUser);
router.route('/contacts').post(AddNewContact).get(handleOtherGetUsers);
module.exports =router;