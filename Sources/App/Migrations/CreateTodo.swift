import FluentKit

struct CreateTodo: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("todos")
            .id()
            .field("title", .string, .required)
            .field("completed", .bool, .required)
            .field("url", .string)
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema("todos").delete()
    }
}
