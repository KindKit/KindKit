//
//  KindKit-Test
//

import XCTest
import KindJSON
import KindJSONMacro

class IdentifierTest : XCTestCase {
    
    public typealias StringId = Identifier< String, IdKind >
    public typealias NumberId = Identifier< UInt, IdKind >
    public enum IdKind : IIdentifierKind {}
    
    func testString() throws {
        do {
            let json = try Document(string: "{\"field\":\"123\"}")
            XCTAssert(try json.decode(StringId.self, in: #Path("field")) == StringId("123"))
        }
        do {
            let json = Document()
            try json.encode(StringId.self, value: StringId("123"), in: #Path("field"))
            XCTAssert(try json.decode(StringId.self, in: #Path("field")) == StringId("123"))
        }
    }
    
    func testNumber() throws {
        do {
            let json = try Document(string: "{\"field\":123}")
            XCTAssert(try json.decode(NumberId.self, in: #Path("field")) == NumberId(123))
        }
        do {
            let json = Document()
            try json.encode(NumberId.self, value: NumberId(123), in: #Path("field"))
            XCTAssert(try json.decode(NumberId.self, in: #Path("field")) == NumberId(123))
        }
    }
    
}
