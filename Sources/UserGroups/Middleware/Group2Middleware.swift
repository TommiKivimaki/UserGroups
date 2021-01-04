// Copyright © 29.12.2020 Tommi Kivimäki.

import Vapor

public struct Group2Middleware<U: Authenticatable & Groupable>: Middleware {

    public init() { }
    
    public func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        guard let user = request.auth.get(U.self),
              user.userGroup == UserGroups.group2 else {
            return request.eventLoop.future(error: Abort(.forbidden))
        }

        return next.respond(to: request)
    }
}
