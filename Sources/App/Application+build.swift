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

    fluent.databases.use(
        DatabaseConfigurationFactory.postgres(
            configuration: .init(
                hostname: "localhost",
                port: 5432,
                username: "hummingbird",
                password: "hummingbird",
                database: "hummingbird",
                tls: .disable)), as: .psql, isDefault: true
    )

    // fluent.databases.use(
    //     DatabaseConfigurationFactory.postgres(
    //         configuration: .init(
    //             hostname: Environment.get("DATABASE_HOST") ?? "localhost",
    //             port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:))
    //                 ?? SQLPostgresConfiguration.ianaPortNumber,
    //             username: Environment.get("DATABASE_USERNAME") ?? "postgres",
    //             password: Environment.get("DATABASE_PASSWORD") ?? "postgres",
    //             database: Environment.get("DATABASE_NAME") ?? "postgres",
    //             tls: .disable)
    //     ), as: .psql)

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
