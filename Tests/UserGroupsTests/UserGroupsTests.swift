import Vapor
import XCTVapor
import FluentPostgresDriver
@testable import UserGroups

final class UserGroupsTests: XCTestCase {
  
  var app: Application!
  
    override func setUpWithError() throws {
        app = try Application.testable()
    }

    override func tearDownWithError() throws {
        app.shutdown()
    }
  
  func testRouteWithoutMiddlewareProtection() throws {
    // Create a route
    let basicAuthRoutes = app.grouped(User.authenticator())
    basicAuthRoutes.get("test") { req -> String in
        let user = try req.auth.require(User.self)
        return user.username
    }

    // Create data for an Authorization header using an existing user
    let authStringUser0 = "user-0:password"
    let authDataUser0 = Data(authStringUser0.utf8)
    let authEncodedDataUser0 = authDataUser0.base64EncodedString()

    try app.test(.GET, "test", headers: HTTPHeaders([("Authorization", "Basic \(authEncodedDataUser0)")]), body: nil, afterResponse: { response in
        XCTAssertEqual(response.status, .ok)
    })


    // Create data for an Authorization header using a nonexistent user
    let authStringNonExistentUser = "nonexistentuser:password"
    let authDataNonExistentUser = Data(authStringNonExistentUser.utf8)
    let authEncodedDataNonExistentUser = authDataNonExistentUser.base64EncodedString()

    try app.test(.GET, "test", headers: HTTPHeaders([("Authorization", "Basic \(authEncodedDataNonExistentUser)")]), body: nil, afterResponse: { response in
        XCTAssertEqual(response.status, .unauthorized)
    })
  }

    func testMiddlewareProtectedRoute() throws {
        // Create a route
        let basicAuthRoutes = app.grouped(User.authenticator())
        let group0Routes = basicAuthRoutes.grouped(Group0Middleware<User>())
        group0Routes.get("test") { req -> String in
            let user = try req.auth.require(User.self)
            return user.username
        }

        // Request using a user-0
        let authStringUser0 = "user-0:password"
        let authDataUser0 = Data(authStringUser0.utf8)
        let authEncodedDataUser0 = authDataUser0.base64EncodedString()

        try app.test(.GET, "test", headers: HTTPHeaders([("Authorization", "Basic \(authEncodedDataUser0)")]), body: nil, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
        })

        // Request using a user-1
        let authStringUser1 = "user-1:password"
        let authDataUser1 = Data(authStringUser1.utf8)
        let authEncodedDataUser1 = authDataUser1.base64EncodedString()

        try app.test(.GET, "test", headers: HTTPHeaders([("Authorization", "Basic \(authEncodedDataUser1)")]), body: nil, afterResponse: { response in
            XCTAssertEqual(response.status, .unauthorized)
        })


        // Request using a nonexistent user
        let authStringNonExistentUser = "nonexistentuser:password"
        let authDataNonExistentUser = Data(authStringNonExistentUser.utf8)
        let authEncodedDataNonExistentUser = authDataNonExistentUser.base64EncodedString()

        try app.test(.GET, "test", headers: HTTPHeaders([("Authorization", "Basic \(authEncodedDataNonExistentUser)")]), body: nil, afterResponse: { response in
            XCTAssertEqual(response.status, .unauthorized)
        })
  }
  
  static var allTests = [
    ("testRouteWithoutMiddlewareProtection", testRouteWithoutMiddlewareProtection),
    ("testMiddlewareProtectedRoute", testMiddlewareProtectedRoute)
  ]
}
