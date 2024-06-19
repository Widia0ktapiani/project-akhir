'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addConstraint('Products', {
      fields: ['createdBy'],
      type: 'foreign key',
      name: 'products-createdBy-association',
      references: {
        table: 'Users',
        field: 'id'
      },
      onDelete: 'CASCADE',
      onUpdate: 'CASCADE'
    });

    await queryInterface.addConstraint('Products', {
      fields: ['updatedBy'],
      type: 'foreign key',
      name: 'products-updatedBy-association',
      references: {
        table: 'Users',
        field: 'id'
      },
      onDelete: 'CASCADE',
      onUpdate: 'CASCADE'
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeConstraint('Products', 'products-createdBy-association');
    await queryInterface.removeConstraint('Products', 'products-updatedBy-association');
  },
};
