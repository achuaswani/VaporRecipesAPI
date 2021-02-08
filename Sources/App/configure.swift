import Fluent
import FluentMongoDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    let connectionStr = Environment.get("DATABASE_URL") ?? "mongodb://localhost:27017/recipes"
    try app.databases.use(.mongo(
        connectionString: connectionStr
    ), as: .mongo)
    
    app.migrations.add(CreateUser())
    app.migrations.add(CreateRecipe())
    app.migrations.add(CreateTodo())

    try app.autoMigrate().wait()
    // register routes
    try routes(app)
}
