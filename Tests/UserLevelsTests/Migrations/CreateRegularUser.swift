// Copyright © 22.12.2020 Tommi Kivimäki.

import Fluent
import Vapor
import UserLevels

struct CreateRegularUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let password = try? Bcrypt.hash("password")
        guard let passwordHash = password else { fatalError("Failed to seed a regular user") }

        let user = User(id: nil,
                        username: "regular-user",
                        password: passwordHash,
                        userLevel: UserLevel(role: "regular"))

        return user.save(on: database)
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        User.query(on: database).filter(\.$username == "regular-user").delete()
    }
}
