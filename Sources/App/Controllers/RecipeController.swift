//
//  File.swift
//  
//
//  Created by Aswani G on 2/7/21.
//

import Fluent
import Vapor

struct RecipeController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let recipes = routes.grouped("api","recipes")
        recipes.get(use: getRecipes)
        //recipes.get(":recipeID", use: getRecipe)
        recipes.post("add", use: createRecipe)
        recipes.group(":recipeID") { recipe in
            recipe.delete(use: delete)
        }
        recipes.delete("deleteAll", use: deleteAll)
    }

    func getRecipes(req: Request) throws -> EventLoopFuture<[Recipe]> {
        return Recipe.query(on: req.db).all()
    }
    
    func getRecipe(req: Request) throws -> EventLoopFuture<Recipe>  {
        return Recipe.find(req.parameters.get("recipeID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }

    func createRecipe(req: Request) throws -> EventLoopFuture<Recipe> {
        let recipe = try req.content.decode(Recipe.self)
        return recipe.save(on: req.db).map { recipe }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Recipe.find(req.parameters.get("recipeID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    func deleteAll(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Recipe.query(on: req.db).delete()
            .flatMap() { _ in
                Recipe.query(on: req.db).delete()
            }.transform(to: .ok)
    }
    
    func importTestData(_ req: Request) throws -> EventLoopFuture<[Todo]> {
       // create & save a category
       return TodoCategory(title: "Blog").save(on: req).flatMap { category in

           // create some todos
           let todos = try [
               Todo(title: "Clean up my desk", categoryID: category.requireID()),
               Todo(title: "Install all updates", categoryID: category.requireID()),
               Todo(title: "Prepare medium blog post", categoryID: category.requireID()),
               Todo(title: "Play with the kids"),
               Todo(title: "Write medium blog post", categoryID: category.requireID()),
               Todo(title: "Publish medium blog post", categoryID: category.requireID())
           ]

           return todos
               .map({ $0.save(on: req) })
               .flatten(on: req)
       }
   }
}
