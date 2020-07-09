import XCTest
import Vapor
import FluentSQLite
import FluentPostgreSQL
import Authentication
@testable import UserLevels

final class UserLevelsTests: XCTestCase {
  
  var app: Application!
  var sqliteConn: SQLiteConnection!
  var psqlConn: PostgreSQLConnection!
  
  let regularSQLiteUser = UserSQLite(username: "regular", password: "password", userLevel: .user)
  let adminSQLUser = UserSQLite(username: "admin", password: "password", userLevel: .admin)
  let regularUser = User(username: "regular", password: "password", userLevel: UserLevel(role: "user"))
  let adminUser = User(username: "admin", password: "password", userLevel: UserLevel(role: "admin"))
  
  override class func setUp() {
    
  }
  
  func testAdminMiddlewareWithSQLiteUsers() throws {
    
    // Boot up services
    var services = Services.default()
    try services.register(FluentProvider())
    try services.register(FluentSQLiteProvider())
    try services.register(AuthenticationProvider())
    
    // Setup DB
    let sqlite = try SQLiteDatabase(storage: .memory)
    var databases = DatabasesConfig()
    databases.add(database: sqlite, as: .sqlite)
    services.register(databases)
    
    var migrations = MigrationConfig()
    migrations.add(model: UserSQLite.self, database: DatabaseIdentifier<UserSQLite.Database>.sqlite)
    services.register(migrations)
    
    // Boot up the app and connect to the DB
    app = try Application(services: services)
    sqliteConn = try app.newConnection(to: .sqlite).wait()
    defer { sqliteConn.close() }
    
    // Save users for testing
    _ = try regularSQLiteUser.save(on: sqliteConn).wait()
    _ = try adminSQLUser.save(on: sqliteConn).wait()
    
    // Router for creating routes and a responder
    let router = try app.make(Router.self)
    let responder = try app.make(Responder.self)
    
    // Create basic auth route
    let basicAuthMiddleware = UserSQLite.basicAuthMiddleware(using: PlaintextVerifier())
    let basicAuthRoutes = router.grouped(basicAuthMiddleware)
    basicAuthRoutes.get("sqliteTest") { req -> String in
      let user = try req.requireAuthenticated(UserSQLite.self)
      return user.username
    }
    
    // Create a request to test the basic auth route
    let basicAuthReq = Request(using: app)
    basicAuthReq.http.method = .GET
    basicAuthReq.http.urlString = "/sqliteTest"
    basicAuthReq.http.headers.basicAuthorization = .init(username: "regular", password: "password")
    let basicAuthResponse = try responder.respond(to: basicAuthReq).wait()
    XCTAssertEqual(basicAuthResponse.http.status, .ok)
    XCTAssertEqual(basicAuthResponse.http.body.description, "regular")
    
    
    // Create a route available to admin only
    let adminMiddleware = AdminMiddlewareSQLite<UserSQLite>()
    let adminRoutes = router.grouped(basicAuthMiddleware, adminMiddleware)
    adminRoutes.get("sqliteAdmin") { req -> String in
      let user = try req.requireAuthenticated(UserSQLite.self)
      return user.username
    }
    
    // Create a request to test the admin only route with a regular user
    let reqWithRegularUser = Request(using: app)
    reqWithRegularUser.http.method = .GET
    reqWithRegularUser.http.urlString = "/sqliteAdmin"
    reqWithRegularUser.http.headers.basicAuthorization = .init(username: "regular", password: "password")
    let regularUserResponse = try responder.respond(to: reqWithRegularUser).wait()
    XCTAssertEqual(regularUserResponse.http.status, .forbidden)
    
    
    // Create a request to test the admin only route with an admin user
    let reqWithAdminUser = Request(using: app)
    reqWithAdminUser.http.method = .GET
    reqWithAdminUser.http.urlString = "/sqliteAdmin"
    reqWithAdminUser.http.headers.basicAuthorization = .init(username: "admin", password: "password")
    let adminUserResponse = try responder.respond(to: reqWithAdminUser).wait()
    XCTAssertEqual(adminUserResponse.http.status, .ok)
    XCTAssertEqual(adminUserResponse.http.body.description, "admin")
  }
  
  
  func testAdminMiddlewareWithUsers() throws {
    // Boot up services
    var services = Services.default()
    try services.register(FluentProvider())
    try services.register(FluentPostgreSQLProvider())
    try services.register(AuthenticationProvider())
    
    // Setup DB
    let postgreConfig: PostgreSQLDatabaseConfig
    let hostname = "localhost"
    let username = "vapor"
    let password = "password"
    let databaseName = "test-db"
    let databasePort = 5432
    postgreConfig = PostgreSQLDatabaseConfig(
      hostname: hostname,
      port: databasePort,
      username: username,
      database: databaseName,
      password: password)
    
    let postgre = PostgreSQLDatabase(config: postgreConfig)
    var databases = DatabasesConfig()
    databases.add(database: postgre, as: .psql)
    services.register(databases)
    
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: DatabaseIdentifier<User.Database>.psql)
    services.register(migrations)
    
    // Boot up the app and connect to the DB
    app = try Application(services: services)
    psqlConn = try app.newConnection(to: .psql).wait()
    defer { psqlConn.close() }
    
    // Save users for testing
    _ = try regularUser.save(on: psqlConn).wait()
    _ = try adminUser.save(on: psqlConn).wait()
    
    // Router for creating routes and a responder
    let router = try app.make(Router.self)
    let responder = try app.make(Responder.self)
    
    // Create basic auth route
    let basicAuthMiddleware = User.basicAuthMiddleware(using: PlaintextVerifier())
    let basicAuthRoutes = router.grouped(basicAuthMiddleware)
    basicAuthRoutes.get("test") { req -> String in
      let user = try req.requireAuthenticated(User.self)
      return user.username
    }
    
    // Create a request to test the basic auth route
    let basicAuthReq = Request(using: app)
    basicAuthReq.http.method = .GET
    basicAuthReq.http.urlString = "/test"
    basicAuthReq.http.headers.basicAuthorization = .init(username: "regular", password: "password")
    let basicAuthResponse = try responder.respond(to: basicAuthReq).wait()
    XCTAssertEqual(basicAuthResponse.http.status, .ok)
    XCTAssertEqual(basicAuthResponse.http.body.description, "regular")
    
    
    // Create a route available to admin only
    let adminMiddleware = AdminMiddleware<User>()
    let adminRoutes = router.grouped(basicAuthMiddleware, adminMiddleware)
    adminRoutes.get("admin") { req -> String in
      let user = try req.requireAuthenticated(User.self)
      return user.username
    }
    
    // Create a request to test the admin only route with a regular user
    let reqWithRegularUser = Request(using: app)
    reqWithRegularUser.http.method = .GET
    reqWithRegularUser.http.urlString = "/admin"
    reqWithRegularUser.http.headers.basicAuthorization = .init(username: "regular", password: "password")
    let regularUserResponse = try responder.respond(to: reqWithRegularUser).wait()
    XCTAssertEqual(regularUserResponse.http.status, .forbidden)
    
    
    // Create a request to test the admin only route with an admin user
    let reqWithAdminUser = Request(using: app)
    reqWithAdminUser.http.method = .GET
    reqWithAdminUser.http.urlString = "/admin"
    reqWithAdminUser.http.headers.basicAuthorization = .init(username: "admin", password: "password")
    let adminUserResponse = try responder.respond(to: reqWithAdminUser).wait()
    XCTAssertEqual(adminUserResponse.http.status, .ok)
    XCTAssertEqual(adminUserResponse.http.body.description, "admin")
  }
  
  static var allTests = [
    ("testAdminMiddlewareWithSQLiteUsers", testAdminMiddlewareWithSQLiteUsers),
    ("testAdminMiddlewareWithUsers", testAdminMiddlewareWithUsers)
  ]
}
