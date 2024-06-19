const productRoute = require ('express').Router();
const ProductController = require('../controllers/ProductController');



productRoute.get('/', ProductController.getAllProducts);
productRoute.get('/category', ProductController.getProductsByCategory);
productRoute.get('/find/:id', ProductController.getProductById);
productRoute.post('/add', ProductController.createProduct);
productRoute.delete('/delete/:id', ProductController.deleteProduct);
productRoute.put('/update/:id', ProductController.updateProduct);

module.exports = productRoute