//
//  KindKit-Test
//

import XCTest
import KindJSON
import KindJSONMacro

class SemaVersionTest : XCTestCase {
    
    func test() throws {
        do {
            let json = try Document(string: "{\"field\":\"1.0\"}")
            XCTAssert(try json.decode(SemaVersion.self, in: #Path("field")) == SemaVersion("1.0")!)
        }
        do {
            let version = SemaVersion("1.0")!
            let json = Document()
            try json.encode(SemaVersion.self, value: version, in: #Path("field"), with: .majorMinor)
            XCTAssert(try json.decode(SemaVersion.self, in: #Path("field")) == version)
        }
    }
    
}
