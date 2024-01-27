//
//  KindKit-Test
//

import XCTest
import KindJSON
import KindJSONMacro

class DictionaryTest : XCTestCase {
    
    func testDecode() throws {
        do {
            let json = try Document(string: "{\"field\":{}}")
            XCTAssertThrowsError(try json.decode([String:Bool].self, in: #Path("field"), with: .nonEmpty))
        }
        do {
            let json = try Document(string: "{\"field\":{\"key_1\":\"123\",\"key_2\":true}}")
            XCTAssert(try json.decode([String:Bool].self, in: #Path("field"), with: .skipInvalid) == ["key_2" : true])
        }
        do {
            let json = try Document(string: "{\"field\":{\"key_1\":true}}")
            XCTAssert(try json.decode([String:Bool].self, in: #Path("field")) == ["key_1" : true])
        }
    }
    
    func testEncode() throws {
        do {
            let json = Document()
            XCTAssertThrowsError(try json.encode([String:Bool].self, value: [:], in: #Path("field"), with: .nonEmpty))
        }
        do {
            let json = Document()
            try json.encode([String:Bool].self, value: ["key_1" : true, "key_2" : true], in: #Path("field"))
            XCTAssert(try json.decode([String:Bool].self, in: #Path("field")) == ["key_1" : true, "key_2" : true])
        }
    }
    
}
