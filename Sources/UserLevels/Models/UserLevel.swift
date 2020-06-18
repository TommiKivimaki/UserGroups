// Copyright © 18.6.2020 Tommi Kivimäki.

import Foundation
import Vapor
import FluentSQLite


public enum UserLevel: String, Content, SQLiteEnumType {
  case admin = "admin"
  case user = "user"
  
  public static func reflectDecoded() throws -> (UserLevel, UserLevel) {
    return (.admin, .user)
  }
}

