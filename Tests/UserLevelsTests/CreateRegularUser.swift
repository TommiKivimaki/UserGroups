// Copyright © 22.12.2020 Tommi Kivimäki.

import Fluent
import Vapor

struct CreateRegularUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(User.schema)
            .id()
            .field("regular-user", .string, .required)
            .unique(on: "username")
            .field("passwordHash", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(User.schema).delete()
    }
}
