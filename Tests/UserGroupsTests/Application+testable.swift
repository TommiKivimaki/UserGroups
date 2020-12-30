// Copyright © 22.12.2020 Tommi Kivimäki.

@testable import UserGroups
import XCTVapor
import Fluent
import FluentPostgresDriver

extension Application {
    static func testable() throws -> Application {
        let app = Application(.testing)

        /// Postgres setup
        let hostname = "localhost"
        let username = "vapor"
        let password = "password"
        let databaseName = "test-db"
        let databasePort = 5432
        let postgresConfig = PostgresConfiguration(hostname: hostname, port: databasePort, username: username, password: password, database: databaseName, tlsConfiguration: nil)
        app.databases.use(.postgres(configuration: postgresConfig),
                          as: .psql)

        // MARK: Run migrations
        app.migrations.add(CreateGroup())
        app.migrations.add(CreateGroup0())
        app.migrations.add(CreateGroup1())
        app.migrations.add(CreateGroup2())
        
        app.migrations.add(CreateUser()) // Create a User table
        app.migrations.add(CreateUserForGroup0()) // Seed a user-0 to the User table
        app.migrations.add(CreateUserForGroup1()) // Seed a user-1 to the User table
        app.migrations.add(CreateUserForGroup2())
//        try app.autoRevert().wait()
        app.logger.logLevel = .debug
        try app.autoMigrate().wait()

        return app
    }
}
