//
//  KindKit-Test
//

import XCTest
import KindJSON
import KindJSONMacro

class NumberTest : XCTestCase {
    
    func testOverflow() throws {
        do {
            let json = try Document(string: "{\"field\":200}")
            XCTAssertThrowsError(try json.decode(Int8.self, in: #Path("field")))
        }
        do {
            let json = try Document(string: "{\"field\":\"200\"}")
            XCTAssertThrowsError(try json.decode(Int8.self, in: #Path("field")))
        }
        do {
            let json = try Document(string: "{\"field\":-1}")
            XCTAssertThrowsError(try json.decode(UInt8.self, in: #Path("field")))
        }
        do {
            let json = try Document(string: "{\"field\":\"-1\"}")
            XCTAssertThrowsError(try json.decode(UInt8.self, in: #Path("field")))
        }
    }
    
    func testInvalid() throws {
        do {
            let json = try Document(string: "{\"field\":[]}")
            XCTAssertThrowsError(try json.decode(Int.self, in: #Path("field")))
        }
    }
    
    func testInteger() throws {
        do {
            let json = try Document(string: "{\"field\":100}")
            XCTAssert(try json.decode(Int.self, in: #Path("field")) == 100)
        }
        do {
            let json = try Document(string: "{\"field\":\"100\"}")
            XCTAssert(try json.decode(Int.self, in: #Path("field")) == 100)
        }
        do {
            let json = Document()
            try json.encode(Int.self, value: 100, in: #Path("field"))
            XCTAssert(try json.decode(Int.self, in: #Path("field")) == 100)
        }
    }
    
    func testUInteger() throws {
        do {
            let json = try Document(string: "{\"field\":100}")
            XCTAssert(try json.decode(UInt.self, in: #Path("field")) == 100)
        }
        do {
            let json = try Document(string: "{\"field\":\"100\"}")
            XCTAssert(try json.decode(UInt.self, in: #Path("field")) == 100)
        }
        do {
            let json = Document()
            try json.encode(UInt.self, value: 100, in: #Path("field"))
            XCTAssert(try json.decode(UInt.self, in: #Path("field")) == 100)
        }
    }
    
    func testFloatingPoint() throws {
        do {
            let json = try Document(string: "{\"field\":100}")
            XCTAssert(try json.decode(Float.self, in: #Path("field")) == 100)
        }
        do {
            let json = try Document(string: "{\"field\":100.5}")
            XCTAssert(try json.decode(Float.self, in: #Path("field")).isNearEqual(100.5))
        }
        do {
            let json = try Document(string: "{\"field\":\"100\"}")
            XCTAssert(try json.decode(Float.self, in: #Path("field")) == 100)
        }
        do {
            let json = try Document(string: "{\"field\":\"100.5\"}")
            XCTAssert(try json.decode(Float.self, in: #Path("field")).isNearEqual(100.5))
        }
        do {
            let json = try Document(string: "{\"field\":\"100,5\"}")
            XCTAssert(try json.decode(Float.self, in: #Path("field")).isNearEqual(100.5))
        }
        do {
            let json = Document()
            try json.encode(Float.self, value: 100, in: #Path("field"))
            XCTAssert(try json.decode(Float.self, in: #Path("field")) == 100)
        }
    }
    
}
