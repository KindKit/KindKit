//
//  KindKit-Test
//

import XCTest
import KindJSON
import KindJSONMacro

class BoolTest : XCTestCase {
    
    func testInvalid() throws {
        do {
            let json = try Document(string: "{\"field\":[]}")
            XCTAssertThrowsError(try json.decode(Bool.self, in: #Path("field")))
        }
    }
    
    func testTrue() throws {
        do {
            let json = try Document(string: "{\"field\":true}")
            XCTAssert(try json.decode(Bool.self, in: #Path("field")) == true)
        }
        do {
            let json = try Document(string: "{\"field\":\"true\"}")
            XCTAssert(try json.decode(Bool.self, in: #Path("field")) == true)
        }
        do {
            let json = try Document(string: "{\"field\":\"yes\"}")
            XCTAssert(try json.decode(Bool.self, in: #Path("field")) == true)
        }
        do {
            let json = try Document(string: "{\"field\":\"on\"}")
            XCTAssert(try json.decode(Bool.self, in: #Path("field")) == true)
        }
        do {
            let json = Document()
            try json.encode(Bool.self, value: true, in: #Path("field"))
            XCTAssert(try json.decode(Bool.self, in: #Path("field")) == true)
        }
    }
    
    func testFalse() throws {
        do {
            let json = try Document(string: "{\"field\":false}")
            XCTAssert(try json.decode(Bool.self, in: #Path("field")) == false)
        }
        do {
            let json = try Document(string: "{\"field\":\"false\"}")
            XCTAssert(try json.decode(Bool.self, in: #Path("field")) == false)
        }
        do {
            let json = try Document(string: "{\"field\":\"no\"}")
            XCTAssert(try json.decode(Bool.self, in: #Path("field")) == false)
        }
        do {
            let json = try Document(string: "{\"field\":\"off\"}")
            XCTAssert(try json.decode(Bool.self, in: #Path("field")) == false)
        }
        do {
            let json = Document()
            try json.encode(Bool.self, value: false, in: #Path("field"))
            XCTAssert(try json.decode(Bool.self, in: #Path("field")) == false)
        }
    }
    
}
