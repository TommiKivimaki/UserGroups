// Copyright © 29.12.2020 Tommi Kivimäki.

import Vapor
import Fluent

public struct CreateGroup0: Migration {
    public func prepare(on database: Database) -> EventLoopFuture<Void> {
        let group = Group(value: UserGroups.group0)
        return group.save(on: database)
    }

    public func revert(on database: Database) -> EventLoopFuture<Void> {
        Group.query(on: database).filter(\.$value == UserGroups.group0).delete()
    }
}
