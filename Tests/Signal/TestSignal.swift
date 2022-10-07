//
//  KindKit-Test
//

import XCTest
import KindKit

class TestSignal : XCTestCase {
    
    func testSet() {
        let signal = Signal.Empty< Void >()
        do {
            var isEmit = false
            let slot = signal.set({
                isEmit = true
            })
            signal.emit()
            if isEmit != true {
                XCTFail("Fail")
            }
        }
        do {
            var isEmit = false
            let slot = signal.set({
                isEmit = true
            })
            slot?.cancel()
            signal.emit()
            if isEmit != false {
                XCTFail("Fail")
            }
        }
    }
    
    func testAppend() {
        let signal = Signal.Empty< Void >()
        do {
            var isEmit = false
            let slot = signal.append({
                isEmit = true
            })
            signal.emit()
            if isEmit != true {
                XCTFail("Fail")
            }
        }
        do {
            var isEmit = false
            _ = signal.append({
                isEmit = true
            })
            signal.emit()
            if isEmit != false {
                XCTFail("Fail")
            }
        }
    }
    
    func testOptional() {
        let signal = Signal.Empty< Bool? >()
        do {
            signal.set({
                return true
            })
            if signal.emit() != true {
                XCTFail("Fail")
            }
        }
    }

}
