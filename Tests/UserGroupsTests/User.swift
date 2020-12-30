// Copyright © 9.7.2020 Tommi Kivimäki.

import Vapor
import Fluent
import UserGroups

struct UserSignup: Content {
    let username: String
    let password: String
}

final class User: Model, Groupable {
    static let schema = "user"

    @ID
    var id: UUID?

    @Field(key: "username")
    var username: String

    @Field(key: "passwordHash")
    var passwordHash: String

    @Field(key: "userGroup")
    var userGroup: Int

    init() { }

    init(id: UUID? = nil,
                username: String,
                password: String,
                userGroup: Int = 9) {
        self.id = id
        self.username = username
        self.passwordHash = password
        self.userGroup = userGroup
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
