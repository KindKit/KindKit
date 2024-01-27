//
//  KindKit-Test
//

import XCTest
import KindText

class TestRange : XCTestCase {
    
    func test() {
        do {
            let range = Text.Range(lower: 1, upper: 3)
            XCTAssert(range.is(contains: 0) == false)
            XCTAssert(range.is(contains: 1) == true)
            XCTAssert(range.is(contains: 2) == true)
            XCTAssert(range.is(contains: 3) == false)
            XCTAssert(range.count == 2)
        }
        do {
            let range = Text.Range(lower: 3, upper: 6)
            XCTAssert(range.is(contains: .init(lower: 0, upper: 3)) == false)
            XCTAssert(range.is(contains: .init(lower: 2, upper: 4)) == false)
            XCTAssert(range.is(contains: .init(lower: 4, upper: 5)) == true)
            XCTAssert(range.is(contains: .init(lower: 5, upper: 7)) == false)
            XCTAssert(range.is(contains: .init(lower: 6, upper: 8)) == false)
        }
        do {
            let range = Text.Range(lower: 3, upper: 6)
            XCTAssert(range.is(intersect: .init(lower: 0, upper: 3)) == false)
            XCTAssert(range.is(intersect: .init(lower: 2, upper: 4)) == true)
            XCTAssert(range.is(intersect: .init(lower: 4, upper: 5)) == true)
            XCTAssert(range.is(intersect: .init(lower: 5, upper: 7)) == true)
            XCTAssert(range.is(intersect: .init(lower: 6, upper: 8)) == false)
        }
    }
    
}
