// Copyright © 18.6.2020 Tommi Kivimäki.

import Foundation
import Vapor
import FluentSQLite


public enum UserLevelSQLite: String, Content, SQLiteEnumType {
  case admin = "admin"
  case user = "user"
  
  public static func reflectDecoded() throws -> (UserLevelSQLite, UserLevelSQLite) {
    return (.admin, .user)
  }
}

