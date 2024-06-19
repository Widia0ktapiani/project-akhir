const { Products, Categories, Users } = require('../models');

class ProductController {
  // API untuk menampilkan semua produk
  static async getAllProducts(req, res) {
    try {
      const products = await Products.findAll({
        include: [
          { model: Categories, as: 'Category' },
          { model: Users, as: 'createdByUser' },
          { model: Users, as: 'updatedByUser' }
        ]
      });
      res.json(products);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  static async getProductsByCategory(req, res) {
    const { categoryId } = req.query;
    try {
      const products = await Products.findAll({
        where: { categoryId },
        include: [
          { model: Categories, as: 'Category' },
          { model: Users, as: 'createdByUser' },
          { model: Users, as: 'updatedByUser' }
        ]
      });
      res.json(products);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  // API untuk menampilkan 1 produk berdasarkan id
  static async getProductById(req, res) {
    const { id } = req.params;
    try {
      const product = await Products.findByPk(id, {
        include: [
          { model: Categories, as: 'Category' },
          { model: Users, as: 'createdByUser' },
          { model: Users, as: 'updatedByUser' }
        ]
      });
      if (!product) {
        return res.status(404).json({ error: 'Product not found' });
      }
      res.json(product);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  // API untuk memasukkan produk baru
  static async createProduct(req, res) {
    const { name, qty, categoryId, imageUrl, createdBy } = req.body;

    try {
      const newProduct = await Products.create({
        name,
        qty,
        categoryId,
        imageUrl,
        createdBy,
        updatedBy: createdBy
      });
      res.status(201).json(newProduct);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  // API untuk mengubah data 1 produk
  static async updateProduct(req, res) {
      const { id } = req.params;
      const { name, qty, categoryId, updatedBy, imageUrl } = req.body;
    
      try {
        // Cari produk terlebih dahulu
        const product = await Products.findByPk(id);
        if (!product) {
          return res.status(404).json({ error: 'Produk tidak ditemukan' });
        }
    
        // Perbarui bidang produk
        product.name = name !== undefined ? name : product.name;
        product.qty = qty !== undefined ? qty : product.qty;
        product.categoryId = categoryId !== undefined ? categoryId : product.categoryId;
        product.updatedBy = updatedBy !== undefined ? updatedBy : product.updatedBy;
    
        // Perbarui imageUrl hanya jika URL gambar baru diberikan
        if (imageUrl !== undefined) {
          product.imageUrl = imageUrl;
        }
    
        await product.save();
    
        res.status(200).json(product);
      } catch (error) {
        res.status(500).json({ error: error.message });
      }
    }
  // API untuk menghapus 1 produk
  static async deleteProduct(req, res) {
    const { id } = req.params;
    try {
      const deleted = await Products.destroy({ where: { id } });
      if (!deleted) {
        return res.status(404).json({ error: 'Product not found' });
      }
      res.status(200).json({ message: 'Product deleted successfully' });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
}

module.exports = ProductController;
