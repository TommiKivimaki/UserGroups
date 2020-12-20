// Copyright © 9.7.2020 Tommi Kivimäki.

import Vapor

public struct AdminMiddleware<U: Authenticatable & UserLevelable>: Middleware {
    public func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        guard let user = request.auth.get(U.self),
              user.userLevel.role == "admin" else {
            return request.eventLoop.future(error: Abort(.forbidden))
        }

        return next.respond(to: request)
    }
}
