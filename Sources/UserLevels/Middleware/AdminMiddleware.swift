// Copyright © 17.6.2020 Tommi Kivimäki.

import Vapor
import Authentication

public struct AdminMiddleware<U: Authenticatable & UserLevelable>: Middleware {
  
  public static func makeService(for container: Container) throws -> AdminMiddleware {
    return .init()
  }
  
  public init() {}
  
  public func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
    guard let user = try request.authenticated(U.self),
      user.userLevel == .admin else {
        throw Abort(.forbidden)
    }
    
    return try next.respond(to: request)
  }
}
