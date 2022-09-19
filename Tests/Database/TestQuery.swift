//
//  KindKit-Test
//

import XCTest
import KindKit

class TestQuery : XCTestCase {
    
    struct User {
        
        let id: Int
        let name: String
        let address: String?
        
    }
    
    struct UserEntity : IDatabaseEntity {
        
        let table: Database.Table
        
        let id: Database.Table.Column< Int >
        let name: Database.Table.Column< String >
        let address: Database.Table.Column< String? >
        
        init(_ name: String) {
            self.table = Database.Table(name: name)
            self.id = self.table.column(name: "id")
            self.name = self.table.column(name: "name")
            self.address = self.table.column(name: "address")
        }
        
    }
    
    struct UserDecoder : IDatabaseDecoder {
        
        let id: Database.KeyPath< Int >
        let name: Database.KeyPath< String >
        let address: Database.KeyPath< String? >
        
        init(_ entity: UserEntity, _ statement: Database.Statement) throws {
            self.id = try statement.keyPath(column: entity.id)
            self.name = try statement.keyPath(column: entity.name)
            self.address = try statement.keyPath(column: entity.address)
        }
        
        func decode(_ statement: Database.Statement) throws -> User {
            return .init(
                id: try statement.decode(self.id),
                name: try statement.decode(self.name),
                address: try statement.decode(self.address)
            )
        }
        
    }
    
    func testUserVersion() throws {
        let db = try Database(location: .inMemory)
        XCTAssert(try db.userVersion() == 0)
        try db.set(userVersion: 1)
        XCTAssert(try db.userVersion() == 1)
    }
    
    func testSmoke() throws {
        let users = UserEntity("users")
        let db = try Database(location: .inMemory)
        try db.run(query: users.create()
            .column(users.id)
            .column(users.name)
            .column(users.address)
        )
        try db.run(query: users.insert()
            .set(1, in: users.id)
            .set("Joe", in: users.name)
            .set("Yaroslavl", in: users.address)
        )
        try db.run(query: users.insert()
            .set(2, in: users.id)
            .set("Alex", in: users.name)
            .set("Batumi", in: users.address)
        )
        try db.run(query: users.insert()
            .set(3, in: users.id)
            .set("Mike", in: users.name)
        )
        try db.run(query: users.insert()
            .set(4, in: users.id)
            .set("Zakhar", in: users.name)
            .set("Yaroslavl", in: users.address)
        )
        try db.run(query: users.insert()
            .set(5, in: users.id)
            .set("Anton", in: users.name)
            .set("Yaroslavl", in: users.address)
        )
        do {
            let result = try db.run(query: users.update()
                .set("Berlin", in: users.address)
                .where(users.id.equal(3))
            )
            XCTAssert(result.numberOfUpdated == 1)
        }
        do {
            let result = try db.run(
                query: users.select().where(users.address.equal("Yaroslavl"))
                    .orderBy(users.name, mode: .asc)
                    .limit(2),
                decode: { try UserDecoder(users, $0) }
            )
            XCTAssert(result.count == 2)
            XCTAssert(result[0].name == "Anton", "Name should be Anton, but was \(result[0].name)")
            XCTAssert(result[1].name == "Joe")
        }
        do {
            let result = try db.run(
                query: users.delete().where(users.address.equal("Yaroslavl")).limit(2)
            )
            XCTAssert(result.numberOfUpdated == 2)
        }
        try db.run(
            query: users.drop()
        )
    }
    
}
