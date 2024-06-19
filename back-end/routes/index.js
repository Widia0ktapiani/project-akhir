const route = require('express').Router()

route.get('/', (req, res) => {
    res.send('Hello Widia!');
  })

const userRoutes = require('./user');
route.use('/users', userRoutes);

const categoryRoutes = require('./category');
route.use('/categories',categoryRoutes);

const productRoutes = require('./product');
route.use('/products',productRoutes);



module.exports = route