// Copyright © 29.12.2020 Tommi Kivimäki.

import Fluent
import Vapor
import UserGroups

struct CreateUserForGroup2: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let password = try? Bcrypt.hash("password")
        guard let passwordHash = password else { fatalError("Failed to seed admin user") }

        let user = User(id: nil,
                        username: "user-2",
                        password: passwordHash,
                        userGroup: 2)

        return user.save(on: database)
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        User.query(on: database).filter(\.$userGroup == 2).delete()
    }
}
