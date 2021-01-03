# UserGroups

User group management package for Vapor backends. Includes middlewares for granting access to routes for a selected user group. 


## Usage 

`UserGroups` can be extended to create a meaningful names for groups. There is one group that has been assigned a meaning by default. The `group0` can be referred as `UserGroups.admin`. 

Example extension: 
```swift
extension UserGroups {
    static var ios-user: Int { group1 }
}
```

## Running tests on macOS

Spin up a Docker container with the following parameters before running tests.
```
docker run --name postgres -e POSTGRES_DB=test-db -e POSTGRES_USER=vapor -e POSTGRES_PASSWORD=password -p 5432:5432 -d postgres
```

## Running tests on Linux

How to run tests inside a container.

Build
```
docker-compose -f docker-compose-dev.yml up --build --abort-on-container-exit
```

Find container ID
```
docker ps
```

Attach
```
docker attach <container id>
```

Then run the tests.
```
swift package clean && swift test
```

