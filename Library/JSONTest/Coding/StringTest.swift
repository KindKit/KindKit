//
//  KindKit-Test
//

import XCTest
import KindJSON
import KindJSONMacro

class StringTest : XCTestCase {
    
    func test() throws {
        do {
            let json = try Document(string: "{\"field\":\"100\"}")
            XCTAssert(try json.decode(String.self, in: #Path("field")) == "100")
        }
        do {
            let json = try Document(string: "{\"field\":100}")
            XCTAssert(try json.decode(String.self, in: #Path("field")) == "100")
        }
        do {
            let json = try Document(string: "{\"field\":10000000000000000000000000000000000000000000000000000}")
            XCTAssert(try json.decode(String.self, in: #Path("field")) == "10000000000000000000000000000000000000000000000000000")
        }
        do {
            let json = try Document(string: "{\"field\":\"\"}")
            XCTAssertThrowsError(try json.decode(String.self, in: #Path("field"), with: .nonEmpty))
        }
        do {
            let json = try Document(string: "{\"field\":{}}")
            XCTAssertThrowsError(try json.decode(String.self, in: #Path("field")))
        }
        do {
            let json = Document()
            try json.encode(String.self, value: "100", in: #Path("field"))
            XCTAssert(try json.decode(String.self, in: #Path("field")) == "100")
        }
    }
    
}
