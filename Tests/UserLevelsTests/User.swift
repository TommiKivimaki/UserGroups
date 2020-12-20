// Copyright © 9.7.2020 Tommi Kivimäki.

import Foundation
import Vapor
import FluentPostgresDriver
import UserLevels

public final class User: Codable, UserLevelable {
  public var id: UUID?
  var username: String
  var password: String
  public var userLevel: UserLevel
  
  
  public init(username: String,
              password: String,
              userLevel: UserLevel = UserLevel(role: "admin")) {
    self.username = username
    self.password = password
    self.userLevel = userLevel
  }
}

extension User: Content {}
extension User: Migration {
  public typealias Database = PostgreSQLDatabase
}
extension User: PostgreSQLUUIDModel {}
extension User: BasicAuthenticatable {
  public static let usernameKey: UsernameKey = \User.username
  public static let passwordKey: PasswordKey = \User.password
}
