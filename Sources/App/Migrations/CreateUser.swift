//
//  File.swift
//  
//
//  Created by Aswani G on 2/7/21.
//

import Fluent

struct CreateUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
       database.schema(User.schema)
           .id()
           .field("username", .string, .required)
           .field("password", .string, .required)
           .unique(on: "username")
           .create()
   }
   
   func revert(on database: Database) -> EventLoopFuture<Void> {
       database.schema(User.schema).delete()
   }
}
