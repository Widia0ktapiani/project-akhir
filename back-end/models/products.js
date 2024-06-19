'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Products extends Model {
    static associate(models) {
      // Relasi Products ke Categories
      Products.belongsTo(models.Categories, { foreignKey: 'categoryId', as: 'Category' });
      models.Categories.hasMany(Products, { foreignKey: 'categoryId', as: 'Category' });

      // Relasi Products ke Users (createdBy)
      Products.belongsTo(models.Users, { foreignKey: 'createdBy', as: 'createdByUser' });
      models.Users.hasMany(Products, { foreignKey: 'createdBy', as: 'createdByUser' });

      // Relasi Products ke Users (updatedBy)
      Products.belongsTo(models.Users, { foreignKey: 'updatedBy', as: 'updatedByUser' });
      models.Users.hasMany(Products, { foreignKey: 'updatedBy', as: 'updatedByUser' });
    }
  };
  Products.init({
    name: DataTypes.STRING,
    qty: DataTypes.INTEGER,
    categoryId: DataTypes.INTEGER,
    imageUrl: DataTypes.STRING,
    createdBy: DataTypes.INTEGER,
    updatedBy: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'Products',
  });
  return Products;
};