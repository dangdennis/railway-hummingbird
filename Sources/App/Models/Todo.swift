import FluentKit
import Foundation
import Hummingbird

/// Database description of a Todo
final class Todo: Model, ResponseCodable, @unchecked Sendable {
    static let schema = "todos"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "url")
    var url: String?

    @Field(key: "completed")
    var completed: Bool

    init() {}

    init(id: UUID? = nil, title: String, url: String? = nil, completed: Bool = false) {
        self.id = id
        self.title = title
        self.url = url
        self.completed = completed
    }

    func update(title: String? = nil, completed: Bool? = nil) {
        if let title = title {
            self.title = title
        }
        if let completed = completed {
            self.completed = completed
        }
    }
}