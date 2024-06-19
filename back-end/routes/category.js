const categoryRoute = require ('express').Router();
const CategoryController = require('../controllers/CategoryController');

categoryRoute.get('/', CategoryController.getCategories);
categoryRoute.post('/add', CategoryController.addCategory);
categoryRoute.put('/update/:id', CategoryController.updateCategory);
categoryRoute.get('/delete/:id', CategoryController.deleteCategory);


module.exports = categoryRoute