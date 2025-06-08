import FluentPostgresDriver
import Foundation
import Hummingbird
import HummingbirdFluent

public protocol AppArguments {
    var hostname: String { get }
    var port: Int { get }
}

func buildApplication(_ arguments: some AppArguments) async throws -> some ApplicationProtocol {
    let logger = Logger(label: "todos-fluent")
    let fluent = Fluent(logger: logger)

    let postgresConfig = SQLPostgresConfiguration(
        hostname: ProcessInfo.processInfo.environment["DATABASE_HOST"] ?? "localhost",
        port: ProcessInfo.processInfo.environment["DATABASE_PORT"].flatMap(Int.init) ?? 5432,
        username: ProcessInfo.processInfo.environment["DATABASE_USERNAME"] ?? "hummingbird",
        password: ProcessInfo.processInfo.environment["DATABASE_PASSWORD"] ?? "hummingbird",
        database: ProcessInfo.processInfo.environment["DATABASE_NAME"] ?? "hummingbird",
        tls: .disable
    )

    fluent.databases.use(
        DatabaseConfigurationFactory.postgres(configuration: postgresConfig),
        as: .psql
    )

    // add migrations
    await fluent.migrations.add(CreateTodo())

    let fluentPersist = await FluentPersistDriver(fluent: fluent)

    try await fluent.migrate()

    // router
    let router = Router()

    // add logging middleware
    router.add(middleware: LogRequestsMiddleware(.info))

    // add file middleware to server css and js files
    router.add(middleware: FileMiddleware(logger: logger))
    router.add(
        middleware: CORSMiddleware(
            allowOrigin: .originBased,
            allowHeaders: [.contentType],
            allowMethods: [.get, .options, .post, .delete, .patch]
        ))

    // add health check route
    router.get("/health") { _, _ in
        return HTTPResponse.Status.ok
    }

    // Add api routes managing todos
    TodoController<BasicRequestContext>(fluent: fluent).addRoutes(to: router.group("api/todos"))

    var app = Application(
        router: router,
        configuration: .init(address: .hostname(arguments.hostname, port: arguments.port))
    )
    app.addServices(fluent, fluentPersist)
    return app
}
