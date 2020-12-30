// Copyright © 9.7.2020 Tommi Kivimäki.

import Fluent
import Vapor

public final class Group: Model {
    public static let schema = "group"

    @ID
    public var id: UUID?

    @Field(key: "value")
    public var value: Int

    public init() { }

    public init(id: UUID? = nil, value: Int) {
        self.id = id
        self.value = value
    }
}

extension Group: Content { }
