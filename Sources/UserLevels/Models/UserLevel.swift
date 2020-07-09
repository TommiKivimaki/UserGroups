// Copyright © 9.7.2020 Tommi Kivimäki.

import Foundation
import Vapor

public struct UserLevel: Content {
  let role: String
  
  public init(role: String) {
    self.role = role
  }
}
