//// Copyright © 17.6.2020 Tommi Kivimäki.
//
//import Vapor
//import Fluent
//import UserLevels
//
//final class UserSQLite: Model, UserLevelable {
//    static let schema = "sqliteUser"
//
//    @ID
//    var id: UUID?
//
//    @Field(key: "username")
//    var username: String
//
//    @Field(key: "passwordHash")
//    var passwordHash: String
//
//    @Field(key: "userLevel")
//    var userLevel: UserLevel
//
//    init() { }
//
//    init(id: UUID? = nil,
//                username: String,
//                password: String,
//                userLevel: UserLevel = UserLevel(role: "admin")) {
//        self.id = id
//        self.username = username
//        self.passwordHash = password
//        self.userLevel = userLevel
//    }
//}
//
//extension UserSQLite: Content {}
//
//extension UserSQLite {
//    func create(from userSignup: UserSignup) throws -> User {
//        User(username: userSignup.username,
//             password: try Bcrypt.hash(userSignup.password) )
//    }
//}
//
//extension UserSQLite: ModelAuthenticatable {
//    static var usernameKey: KeyPath<User, Field<String>> = \UserSQLite.$username
//
//    static var passwordHashKey: KeyPath<User, Field<String>> = \UserSQLite.$passwordHash
//
//    func verify(password: String) throws -> Bool {
//        try Bcrypt.verify(password, created: self.passwordHash)
//    }
//}
