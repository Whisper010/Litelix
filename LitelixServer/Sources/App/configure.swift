import Vapor
import Fluent
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    // register routes
    
    //Connecting remote database || Change arguments if you want to connect to another database
    app.databases.use(.postgres(hostname: "tyke.db.elephantsql.com", username: "uasovirp", password: "hBExTWMZE6EU-ZWKgY_MtpLPikdXJocl",database: "uasovirp"), as: .psql)
    
    //Local database
    
//    app.databases.use(.postgres(hostname: Environment.get("DATABASE_HOST") ?? "localhost",
//                                port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
//                                username: Environment.get("DATABASE_USERNAME")?? "vapor_username",
//                                password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
//                                database: Environment.get("DATABASE_NAME")?? "vapor_database"), as: .psql)
//    
    
    
    // register migration
    app.migrations.add(CreateUsersTableMigration())
    
    try await app.autoMigrate()
    
    
    try routes(app)
}
