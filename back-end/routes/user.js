const express = require('express');
const userRoute = express.Router();
const UserController = require('../controllers/UserController');
const upload = require('../config/multerConfig');


userRoute.post('/login', UserController.login);
userRoute.post('/register', upload.single('image'), UserController.register);


module.exports = userRoute;
