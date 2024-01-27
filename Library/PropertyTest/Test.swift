//
//  KindKit-Test
//

import XCTest
import KindProperty

class Test : XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        self.continueAfterFailure = false
    }
    
    func testCondition() {
    }
    
    func testProperty() {
        do {
            let value = ValueProperty< Int >(scope: .default, value: 1)
            XCTAssertEqual(value.value, 1)
            value.value = 2
            XCTAssertEqual(value.value, 2)
        }
        do {
            let value = ValueProperty< Int >(scope: .default, value: 1)
            let optional = OptionalProperty(scope: .default)
                .property(value)
            XCTAssertEqual(optional.value, 1)
            value.value = 2
            XCTAssertEqual(optional.value, 2)
        }
        do {
            let value = ValueProperty< Int >(scope: .default, value: 1)
            let lazy = LazyProperty< Int >(
                scope: .default,
                callback: RegularCallback(callback: {
                    return value.value
                })
            )
            XCTAssertEqual(lazy.value, 1)
            value.value = 2
            lazy.requestChange()
            XCTAssertEqual(lazy.value, 2)
        }
        do {
            let a = ValueProperty< Int >(scope: .default, value: 1)
            let b = ValueProperty< Int >(scope: .default, value: 1)
            let c = ValueProperty< Int >(scope: .default, value: 1)
            let lazy = LazyProperty< Int >(
                scope: .default,
                dependencies: [ a, b, c ],
                callback: RegularCallback(callback: {
                    a.value + b.value + c.value
                })
            )
            XCTAssertEqual(lazy.value, 3)
            a.value = 2
            XCTAssertEqual(lazy.value, 4)
            b.value = 2
            XCTAssertEqual(lazy.value, 5)
            c.value = 2
            XCTAssertEqual(lazy.value, 6)
        }
    }
    
}
