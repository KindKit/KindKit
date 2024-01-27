//
//  KindKit-Test
//

import XCTest
import KindJSON
import KindJSONMacro

class RawRepresentableTest : XCTestCase {
    
    enum Enum : String, ValueCoderTrait {
        
        case case1 = "case_1"
        case case2 = "case_2"
        case case3 = "case_3"
        
    }
    
    func test() throws {
        do {
            let json = try Document(string: "{\"field\":\"case_2\"}")
            XCTAssert(try json.decode(Enum.self, in: #Path("field")) == .case2)
        }
        do {
            let json = Document()
            try json.encode(Enum.self, value: .case2, in: #Path("field"))
            XCTAssert(try json.decode(Enum.self, in: #Path("field")) == .case2)
        }
    }
    
}
