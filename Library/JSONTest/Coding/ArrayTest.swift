//
//  KindKit-Test
//

import XCTest
import KindJSON
import KindJSONMacro

class ArrayTest : XCTestCase {
    
    func testDecode() throws {
        do {
            let json = try Document(string: "{\"field\":[]}")
            XCTAssertThrowsError(try json.decode([Int].self, in: #Path("field"), with: .nonEmpty))
        }
        do {
            let json = try Document(string: "{\"field\":[\"zero\",1,2,3,4]}")
            XCTAssert(try json.decode([Int].self, in: #Path("field"), with: .skipInvalid) == [1, 2, 3, 4])
        }
        do {
            let json = try Document(string: "{\"field\":[0,1,2,3,4]}")
            XCTAssert(try json.decode([Int].self, in: #Path("field")) == [0, 1, 2, 3, 4])
        }
    }
    
    func testEncode() throws {
        do {
            let json = Document()
            XCTAssertThrowsError(try json.encode([Int].self, value: [], in: #Path("field"), with: .nonEmpty))
        }
        do {
            let json = Document()
            try json.encode([Int].self, value: [0, 1, 2, 3, 4], in: #Path("field"))
            XCTAssert(try json.decode([Int].self, in: #Path("field")) == [0, 1, 2, 3, 4])
        }
    }
    
}
