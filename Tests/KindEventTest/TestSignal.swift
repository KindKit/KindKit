//
//  KindKit-Test
//

import XCTest
import KindEvent

class TestSignal : XCTestCase {
    
    func testAppend() {
        let signal = Signal< Void, Void >()
        do {
            var isEmit = false
            let slot = signal.add({
                isEmit = true
            }).autoCancel()
            signal.emit()
            if isEmit != true {
                XCTFail("Fail")
            }
        }
        do {
            var isEmit = false
            _ = signal.add({
                isEmit = true
            }).autoCancel()
            signal.emit()
            if isEmit != false {
                XCTFail("Fail")
            }
        }
    }
    
    func testOptional() {
        let signal = Signal< Bool?, Void >()
        do {
            signal.add({
                return true
            })
            if signal.emit() != true {
                XCTFail("Fail")
            }
        }
    }

}
