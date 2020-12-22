// Copyright © 22.12.2020 Tommi Kivimäki.

@testable import UserLevels
import XCTVapor
import Fluent
import FluentSQLiteDriver
import FluentPostgresDriver

extension Application {
    static func testable() throws -> Application {
        let app = Application(.testing)

        /// SQLite setup
//        let sqliteConfig = SQLiteConfiguration(storage: .memory)
//        app.databases.use(.sqlite(sqliteConfig,
//                                  maxConnectionsPerEventLoop: 1),
//                          as: .sqlite)

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
        app.migrations.add(CreateAdminUser())
        app.migrations.add(CreateRegularUser())
        try app.autoRevert().wait()
        try app.autoMigrate().wait()

        return app
    }
}
