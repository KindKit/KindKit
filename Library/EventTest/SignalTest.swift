//
//  KindKit-Test
//

import Testing
import KindEvent

struct Test {
    
    @Test
    func append() {
        let signal = Signal< Void, Void >()
        do {
            var isEmit = false
            let slot = signal.connect(regular: {
                isEmit = true
            }).autoCancel()
            signal.emit()
            #expect(isEmit == true)
        }
        do {
            var isEmit = false
            _ = signal.connect(regular: {
                isEmit = true
            }).autoCancel()
            signal.emit()
            #expect(isEmit == false)
        }
    }
    
    @Test
    func optional() {
        let signal = Signal< Bool?, Void >()
        do {
            signal.connect(regular: {
                return true
            })
            #expect(signal.emit() == true)
        }
    }

}
