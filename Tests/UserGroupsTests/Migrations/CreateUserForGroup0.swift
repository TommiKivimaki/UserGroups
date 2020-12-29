// Copyright © 22.12.2020 Tommi Kivimäki.

import Fluent
import Vapor
import UserGroups

struct CreateUserForGroup0: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let password = try? Bcrypt.hash("password")
        guard let passwordHash = password else { fatalError("Failed to seed admin user") }

        let user = User(id: nil,
                        username: "user-0",
                        password: passwordHash,
                        userGroup: UserGroups.admin)

        return user.save(on: database)
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        User.query(on: database).filter(\.$userGroup == 0).delete()
    }
}
