const { Categories } = require('../models');

class CategoryController {
    static getCategories(req, res){
        Categories.findAll()

        .then(result => {
            res.json(result)
        })
        .catch(err => {
            res.json(err)
        })
    }

    static addCategory(req, res) {
        
        let name = req.body.name; 
        
        Categories.create({
            name 
        })
            .then(result =>{
                res.json(result)
            })
            .catch(err =>{
                res.json(err)
            })
    }    

    static deleteCategory (req, res){

        let id = +req.params.id
    
        Categories.destroy({
            where: {
                id
            }
        })
            .then(result =>{
                if(result == 1){
                res.json({
                    massage: "Category has been deleted!"
                })
                }else{
                res.json({
                    massage: "Category failed to delete"
                })
                }
            })
            .catch(err =>{
                res.json(err)
            })
    }

    static updateCategory(req, res){
        let id = +req.params.id
        let name = req.body.name

        Categories.update({
            name
        }, {
            where : {
                id
            }
        })
        .then(result =>{
            if(result == 1){
            res.json({
                massage: "Successful category update!"
            })
            }else{
                res.json({
                    massage: "Category failed to delete"
                })
            }
        })
        .catch(err =>{
            res.json(err)
        })
    }
}

module.exports = CategoryController;