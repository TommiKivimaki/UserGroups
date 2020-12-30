// Copyright © 29.12.2020 Tommi Kivimäki.

import Fluent

public struct CreateGroup: Migration {
    public func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Group.schema)
            .id()
            .field("value", .int, .required)  // FIXME: MUST be unique
            .create()
    }

    public func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Group.schema).delete()
    }
}
