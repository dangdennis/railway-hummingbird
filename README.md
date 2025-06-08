# Hummingbird Swift Web API Template

A production-ready Hummingbird web framework template for containerized deployment. This template includes a complete REST API with database integration, perfect for building modern web applications and APIs.

## ✨ Features

- **Swift 6.0** with Hummingbird web framework
- **Postgres database** with Fluent ORM
- **RESTful API** with Todo CRUD operations
- **Docker** containerization for consistent deployment
- **Production-ready** configuration with optimized builds
- **CORS support** for cross-origin requests

## 🚀 One-Click Deploy

Deploy this template to Railway with a single click:

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/JOQEiS?referralCode=mT7-6r)

## 🛠 Local Development

### Prerequisites

- Swift 6.0 or later
- Docker (for database)

### Setup

1. Clone the repository:
```bash
git clone https://github.com/dangdennis/railway-hummingbird
cd App
```

2. Run Postgres via docker compose:
```bash
docker compose up -d
```

3. Build the project:
```bash
swift build
```

4. Run the server:
```bash
swift run
```

The server will start on `http://localhost:8080`

### API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/todos` | Get all todos |
| POST | `/api/todos` | Create a new todo |
| GET | `/api/todos/:id` | Get a specific todo by ID |
| PATCH | `/api/todos/:id` | Update a todo by ID |
| DELETE | `/api/todos/:id` | Delete a todo by ID |
| GET | `/health` | Health check endpoint |

### Example Usage

```bash
# Health check
curl http://localhost:8080/health

# Get all todos
curl http://localhost:8080/api/todos

# Create a new todo
curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title": "Learn Hummingbird"}'

# Get a specific todo
curl http://localhost:8080/api/todos/YOUR_TODO_ID

# Update a todo
curl -X PATCH http://localhost:8080/api/todos/YOUR_TODO_ID \
  -H "Content-Type: application/json" \
  -d '{"title": "Updated title", "completed": true}'

# Delete a todo
curl -X DELETE http://localhost:8080/api/todos/YOUR_TODO_ID
```

## 🐳 Docker

Build and run with Docker:

```bash
# Build the image
docker build -t hummingbird-app .

# Run with environment variables for database connection
docker run -p 8080:8080 \
  -e DATABASE_HOST=localhost \
  -e DATABASE_PORT=5432 \
  -e DATABASE_USERNAME=hummingbird \
  -e DATABASE_PASSWORD=hummingbird \
  -e DATABASE_NAME=hummingbird \
  hummingbird-app
```

## 🧪 Testing

Run the test suite:

```bash
swift test
```

## 📁 Project Structure

```
Sources/App/
├── Controllers/        # Route handlers
│   └── TodoController.swift
├── Models/            # Database models
│   └── Todo.swift
├── Migrations/        # Database migrations
│   └── CreateTodo.swift
├── App.swift          # App entry point
└── Application+build.swift # App configuration
```

## 🔧 Configuration

The app supports environment-based configuration:

- `DATABASE_HOST` - Database hostname (default: `localhost`)
- `DATABASE_PORT` - Database port (default: `5432`)
- `DATABASE_USERNAME` - Database username (default: `hummingbird`)
- `DATABASE_PASSWORD` - Database password (default: `hummingbird`)
- `DATABASE_NAME` - Database name (default: `hummingbird`)

## 📚 Learn More

- [Hummingbird Documentation](https://docs.hummingbird.codes)
- [Swift Package Manager](https://www.swift.org/documentation/package-manager/)
- [Fluent Documentation](https://docs.vapor.codes/fluent/overview/)

## 📄 License

This template is available as open source under the terms of the [MIT License](LICENSE).
