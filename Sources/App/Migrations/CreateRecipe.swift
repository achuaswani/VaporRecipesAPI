//
//  File.swift
//  
//
//  Created by Aswani G on 2/7/21.
//

import Fluent

struct CreateRecipe: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
       database.schema(Recipe.schema)
           .id()
           .field("title", .string, .required)
           .field("category", .string, .required)
           .field("description", .string)
           .field("image", .string)
           .field("ingredients", .string, .required)
           .field("steps", .string)
           .field("tips", .string)
           .field("author", .string)
           .field("dateTime", .string)
           .create()
   }
   
   func revert(on database: Database) -> EventLoopFuture<Void> {
       database.schema(User.schema).delete()
   }
}
