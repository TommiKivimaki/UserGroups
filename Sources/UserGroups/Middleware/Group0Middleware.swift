// Copyright © 9.7.2020 Tommi Kivimäki.

import Vapor

public struct Group0Middleware<U: Authenticatable & Groupable>: Middleware {
    public func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        guard let user = request.auth.get(U.self),
              user.userGroup == UserGroups.group0 else {
            return request.eventLoop.future(error: Abort(.unauthorized))
        }
        
        return next.respond(to: request)
    }
}
