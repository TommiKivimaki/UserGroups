// Copyright © 29.12.2020 Tommi Kivimäki.

import Vapor
import Fluent

public struct CreateGroup1: Migration {
    public func prepare(on database: Database) -> EventLoopFuture<Void> {
        let group = Group(value: UserGroups.group1)
        return group.save(on: database)
    }

    public func revert(on database: Database) -> EventLoopFuture<Void> {
        Group.query(on: database).filter(\.$value == UserGroups.group1).delete()
    }
}
