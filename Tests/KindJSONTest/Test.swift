//
//  KindKit-Test
//

import XCTest
import KindJSON

class Test : XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        self.continueAfterFailure = false
    }
    
    func testDecode() throws {
        let json = try Document(
            path: [ "other" ],
            string: "{\"a\":\"123\",\"b\":\"qwe\"}"
        )
        do {
            let a = try json.decode(String.self, path: [ "a" ])
            XCTAssert(a == "123")
        }
        do {
            let a = try json.decode(Int.self, path: [ "a" ])
            XCTAssert(a == 123)
        }
        do {
            _ = try json.decode(Int.self, path: [ "c" ])
        } catch let error as Error.Coding {
            switch error {
            case .access(let path):
                if path.string != "other.c" {
                    XCTFail(path.description)
                }
            case .cast(let path):
                XCTFail(path.description)
            }
        }
        do {
            _ = try json.decode(Int.self, path: [ "b" ])
        } catch let error as Error.Coding {
            switch error {
            case .access(let path):
                XCTFail(path.description)
            case .cast(let path):
                if path.string != "other.b" {
                    XCTFail(path.description)
                }
            }
        }
    }
    
}
