// Copyright © 17.6.2020 Tommi Kivimäki.

import Foundation
import Vapor
import FluentSQLiteDriver
import UserLevels

public final class UserSQLite: Codable, UserLevelableSQLite {
  public var id: UUID?
  var username: String
  var password: String
  public var userLevel: UserLevelSQLite
  
  
  public init(username: String,
              password: String,
              userLevel: UserLevelSQLite = .user) {
    self.username = username
    self.password = password
    self.userLevel = userLevel
  }
}

extension UserSQLite: Content {}
extension UserSQLite: Migration {
  public typealias Database = SQLiteDatabase
}
extension UserSQLite: SQLiteUUIDModel {}
extension UserSQLite: BasicAuthenticatable {
  public static let usernameKey: UsernameKey = \UserSQLite.username
  public static let passwordKey: PasswordKey = \UserSQLite.password
}
