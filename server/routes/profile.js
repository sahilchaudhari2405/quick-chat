const express = require('express');
const router = express.Router();

const { handleUpdateUserInfo } = require('../controller/update_user');
const { handleGetUser } = require('../controller/get_profile');
const app = express();
const upload = require('../middleware/multer.middleware'); 

router.post('/:user_id', upload.single('profile_picture'), handleUpdateUserInfo);
router.get('/:id',handleGetUser);
module.exports = router;
