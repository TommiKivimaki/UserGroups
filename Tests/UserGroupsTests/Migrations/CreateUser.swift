// Copyright © 23.12.2020 Tommi Kivimäki.

import Fluent
import UserGroups

struct CreateUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(User.schema)
            .id()
            .field("username", .string, .required)
            .field("passwordHash", .string, .required)
            .field("userGroup", .int, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(User.schema).delete()
    }
}
