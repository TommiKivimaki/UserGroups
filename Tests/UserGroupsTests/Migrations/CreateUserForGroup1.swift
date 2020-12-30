// Copyright © 22.12.2020 Tommi Kivimäki.

import Fluent
import Vapor
import UserGroups

struct CreateUserForGroup1: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let password = try? Bcrypt.hash("password")
        guard let passwordHash = password else { fatalError("Failed to seed a regular user") }

        let user = User(id: nil,
                        username: "user-1",
                        password: passwordHash,
                        userGroup: 1)

        return user.save(on: database)
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        User.query(on: database).filter(\.$userGroup == 1).delete()
    }
}
