const express = require('express');
const app = express();
const port = process.env.PORT || 3000;
const ip = '10.10.11.199';
const bodyParser = require('body-parser');
const path = require('path');

app.use(bodyParser.json());
app.use(express.json());
app.use(express.urlencoded({extended: true }));

const routes = require('./routes'); 
app.use(routes);

app.listen(port, ip, () => {
  console.log(`Server running at http://${ip}:${port}/`);
});




// app.use(express.static(path.join(__dirname, 'uploads')));
// app.use('/uploads', express.static(path.join(__dirname, 'uploads')));