// Copyright © 17.6.2020 Tommi Kivimäki.

import Vapor

public struct AdminMiddlewareSQLite<U: Authenticatable & UserLevelableSQLite>: Middleware {

    public func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        guard let user = request.auth.get(U.self),
              user.userLevel == .admin else {
            return request.eventLoop.future(error: Abort(.forbidden))
        }

        return next.respond(to: request)
    }
}
