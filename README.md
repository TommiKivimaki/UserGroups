# UserLevels

User level management package for Vapor backends. Includes an `AdminMiddleware` for granting only admin access to routes.

`AdminMiddlewareSQLite` uses an enum to define a user level and it works with `FluentSQLite` by implementing the `reflectDecoded()` and conforming to `SQLiteEnumType`.

`AdminMiddleware` uses a struct for user roles and works fine e.g. with `FluentPostgreSQL` 

## Running tests

`testAdminMiddlewareWithUsers` needs a Postgres instance before it can run. Spin up a Docker container with the following parameters:
```
docker run --name postgres \                                                              (dev)Bedrock
-e POSTGRES_DB=test-db \
-e POSTGRES_USER=vapor \
-e POSTGRES_PASSWORD=password \
-p 5432:5432 -d postgres
```

