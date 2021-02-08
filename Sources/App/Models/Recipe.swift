//
//  File.swift
//  
//
//  Created by Aswani G on 2/7/21.
//

import Fluent
import Vapor

final class Recipe: Model, Content {
    // Name of the table
    static let schema = "recipe"
    
    // Unique Id for recipe
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    @Field(key: "category")
    var category: String
    @Field(key: "description")
    var description: String?
    @Field(key: "image")
    var image: String?
    @Field(key: "ingredients")
    var ingredients: String
    @Field(key: "steps")
    var steps: String?
    @Field(key: "tips")
    var tips: String?
    @Field(key: "author")
    var author: String?
    @Field(key: "dateTime")
    var dateTime: String?
    init() { }
    init(id: UUID? = nil,
         title: String,
         category: String,
         description: String? = "",
         image: String? = "",
         ingredients: String,
         steps: String? = "",
         tips: String? = "",
         author: String? = "",
         dateTime: String?) {
        self.id = id
        self.title = title
        self.category = category
        self.description = description
        self.image = image
        self.ingredients = ingredients
        self.steps = steps
        self.tips = tips
        self.author = author
        let today = Date()
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        self.dateTime = dateTime ?? formatter1.string(from: today)
        
    }
}
