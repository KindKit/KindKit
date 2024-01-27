//
//  KindKit-Test
//

import XCTest
import KindJSON
import KindJSONMacro

class OptionalTest : XCTestCase {
    
    func testDecode() throws {
        do {
            let json = try Document(string: "{\"field\":100}")
            XCTAssert(try json.decode(Int?.self, in: #Path("field")) == 100)
        }
        do {
            let json = try Document(string: "{\"field\":null}")
            XCTAssert(try json.decode(Int?.self, in: #Path("field")) == nil)
        }
        do {
            let json = try Document(string: "{}")
            XCTAssert(try json.decode(Int?.self, in: #Path("field")) == nil)
        }
        do {
            let json = try Document(string: "{\"field\":null}")
            XCTAssert(try json.decode(Int?.self, in: #Path("field"), with: .default(100)) == 100)
        }
    }
    
    func testEncode() throws {
        do {
            let json = try Document(string: "{}")
            XCTAssert(try json.decode(Int?.self, in: #Path("field"), with: .default(100)) == 100)
        }
        do {
            let json = Document()
            try json.encode(Int?.self, value: 100, in: #Path("field"))
            XCTAssert(try json.decode(Int?.self, in: #Path("field")) == 100)
        }
        do {
            let json = Document()
            try json.encode(Int?.self, value: nil, in: #Path("field"))
            XCTAssert(try json.decode(Int?.self, in: #Path("field")) == nil)
        }
        do {
            let json = Document()
            try json.encode(Int?.self, value: nil, in: #Path("field"), with: .nullable)
            XCTAssert(try json.get(in: #Path("field")) is NSNull)
        }
    }
    
}
