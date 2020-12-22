// Copyright © 9.7.2020 Tommi Kivimäki.

import Vapor
import Fluent
import UserLevels

struct UserSignup: Content {
    let username: String
    let password: String
}

final class User: Model, UserLevelable {
    static let schema = "user"

    @ID
    var id: UUID?

    @Field(key: "username")
    var username: String

    @Field(key: "passwordHash")
    var passwordHash: String

    @Field(key: "userLevel")
    var userLevel: UserLevel

    init() { }

    init(id: UUID? = nil,
                username: String,
                password: String,
                userLevel: UserLevel = UserLevel(role: "admin")) {
        self.id = id
        self.username = username
        self.passwordHash = password
        self.userLevel = userLevel
    }
}

extension User: Content {}

extension User {
    func create(from userSignup: UserSignup) throws -> User {
        User(username: userSignup.username,
             password: try Bcrypt.hash(userSignup.password) )
    }
}

extension User: ModelAuthenticatable {
    static var usernameKey: KeyPath<User, Field<String>> = \User.$username

    static var passwordHashKey: KeyPath<User, Field<String>> = \User.$passwordHash

    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.passwordHash)
    }
}
