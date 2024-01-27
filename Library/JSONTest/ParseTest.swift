//
//  KindKit-Test
//

import XCTest
import KindJSON

class ParseTest : XCTestCase {
    
    func testFrom() throws {
        let string = "{\"field\":{}}"
        let jsonFromString = try Document(string: string)
        if let data = string.data(using: .utf8) {
            let jsonFromData = try Document(data: data)
            XCTAssert(jsonFromString == jsonFromData)
        } else {
            XCTFail()
        }
    }
    
    func testError() throws {
        do {
            _ = try Document(string: "")
        } catch let error {
            switch error {
            case .notJson:
                break
            }
        }
        do {
            _ = try Document(string: "{\"field\":}")
        } catch let error {
            switch error {
            case .notJson:
                break
            }
        }
    }
    
}
