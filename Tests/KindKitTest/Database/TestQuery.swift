//
//  KindKit-Test
//

import XCTest
import KindKit

class TestQuery : XCTestCase {
    
    struct User {
        
        let id: Int
        let name: String
        let homeAddress: AddressModel
        let workAddress: AddressModel?
        
    }
    
    struct UserEntity : IDatabaseEntity {
        
        enum Column {
            
            typealias Id = Database.Table.Column.Alias< Int >
            typealias Name = Database.Table.Column.Alias< String >
            typealias HomeAddress = Database.Table.Column.Alias< AddressModel >
            typealias WorkAddress = Database.Table.Column.Alias< AddressModel? >
            
        }
        
        let table: Database.Table
        
        let id: Column.Id
        let name: Column.Name
        let homeAddress: Column.HomeAddress
        let workAddress: Column.WorkAddress
        
        init(_ name: String) {
            self.table = Database.Table(name: name)
            self.id = self.table.column(name: "id")
            self.name = self.table.column(name: "name")
            self.homeAddress = self.table.column(name: "home_address")
            self.workAddress = self.table.column(name: "work_address")
        }
        
    }
    
    struct UserDecoder : IDatabaseDecoder {
        
        let id: Database.KeyPath< UserEntity.Column.Id >
        let name: Database.KeyPath< UserEntity.Column.Name >
        let homeAddress: Database.KeyPath< UserEntity.Column.HomeAddress >
        let workAddress: Database.KeyPath< UserEntity.Column.WorkAddress >
        
        init(_ entity: UserEntity, _ statement: Database.Statement) throws {
            self.id = try statement.keyPath(column: entity.id)
            self.name = try statement.keyPath(column: entity.name)
            self.homeAddress = try statement.keyPath(column: entity.homeAddress)
            self.workAddress = try statement.keyPath(column: entity.workAddress)
        }
        
        func decode(_ statement: Database.Statement) throws -> User {
            return .init(
                id: try statement.decode(self.id),
                name: try statement.decode(self.name),
                homeAddress: try statement.decode(self.homeAddress),
                workAddress: try statement.decode(self.workAddress)
            )
        }
        
    }
    
    struct AddressModel : IJsonModelCoder, IDatabaseValueAlias {
        
        typealias JsonModelDecoded = Self
        typealias JsonModelEncoded = Self
        
        let city: String
        
        static func decode(_ json: KindKit.Json) throws -> JsonModelDecoded {
            return .init(
                city: try json.decode(String.self, path: [ "city" ])
            )
        }
        
        static func encode(_ model: JsonModelEncoded, json: KindKit.Json) throws {
            try json.encode(String.self, value: model.city, path: [ "city" ])
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
            .column(users.homeAddress)
            .column(users.workAddress)
        )
        try db.run(query: users.insert()
            .set(1, in: users.id)
            .set("Joe", in: users.name)
            .set(.init(city: "Yaroslavl"), in: users.homeAddress)
            .set(.init(city: "Yaroslavl"), in: users.workAddress)
        )
        try db.run(query: users.insert()
            .set(2, in: users.id)
            .set("Alex", in: users.name)
            .set(.init(city: "Batumi"), in: users.homeAddress)
            .set(.init(city: "Batumi"), in: users.workAddress)
        )
        try db.run(query: users.insert()
            .set(3, in: users.id)
            .set("Mike", in: users.name)
            .set(.init(city: "London"), in: users.homeAddress)
        )
        try db.run(query: users.insert()
            .set(4, in: users.id)
            .set("Zakhar", in: users.name)
            .set(.init(city: "Yaroslavl"), in: users.homeAddress)
            .set(.init(city: "Yaroslavl"), in: users.workAddress)
        )
        try db.run(query: users.insert()
            .set(5, in: users.id)
            .set("Anton", in: users.name)
            .set(.init(city: "Yaroslavl"), in: users.homeAddress)
            .set(.init(city: "Yaroslavl"), in: users.workAddress)
        )
        do {
            let result = try db.run(query: users.update()
                .set(.init(city: "Berlin"), in: users.workAddress)
                .where(users.id.equal(3))
            )
            XCTAssert(result.numberOfUpdated == 1)
        }
        do {
            let result = try db.run(
                query: users.select()
                    .where(users.homeAddress.equal(.init(city: "Yaroslavl")))
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
                query: users.delete()
                    .where(users.homeAddress.equal(.init(city: "Yaroslavl")))
                    .limit(2)
            )
            XCTAssert(result.numberOfUpdated == 2)
        }
        try db.run(
            query: users.drop()
        )
    }
    
}
