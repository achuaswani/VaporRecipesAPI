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
        recipes.get(":recipeId", use: getRecipe)
        recipes.get("start", ":start", "end", ":end", use: getRecipesByRange)
        recipes.post("add", use: createRecipe)
        recipes.delete(":recipeId", use: delete)
        recipes.delete("deleteAll", use: deleteAll)
    }

    func getRecipes(req: Request) throws -> EventLoopFuture<[Recipe]> {
        return Recipe.query(on: req.db).all()
    }
    
    
    func getRecipesByRange(req: Request) throws -> EventLoopFuture<[Recipe]> {
        guard let startText = req.parameters.get("start"), let start = Int(startText),
        let endText = req.parameters.get("end"), let end = Int(endText)  else {
            throw Abort(.badRequest)
        }
        let range = start...end
        return Recipe.query(on: req.db).range(range).all()
    }
    
    
    func getRecipe(req: Request) throws -> EventLoopFuture<Recipe>  {
        return Recipe.find(req.parameters.get("recipeId"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }

    func createRecipe(req: Request) throws -> EventLoopFuture<Recipe> {
        let recipe = try req.content.decode(Recipe.self)
        return recipe.save(on: req.db).map { recipe }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Recipe.find(req.parameters.get("recipeId"), on: req.db)
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
}
