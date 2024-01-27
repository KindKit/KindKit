//
//  KindKit-Test
//

import XCTest
@testable import KindAnimation

class Test : XCTestCase {
    
    func testParallel() {
        let b1 = BlockAction(duration: 1.seconds)
        let b2 = BlockAction(duration: 0.5.seconds)
        let b3 = BlockAction(duration: 2.seconds)
        
        let manager = Manager()
        manager.run(
            ParallelAction(builder: {
                b1
                b2
                b3
            })
        )
        
        do {
            manager.update(0.25.seconds)
            XCTAssert(b1.state == .working)
            XCTAssert(b2.state == .working)
            XCTAssert(b3.state == .working)
        }
        do {
            manager.update(0.5.seconds)
            XCTAssert(b1.state == .working)
            XCTAssert(b2.state == .completed)
            XCTAssert(b3.state == .working)
        }
        do {
            manager.update(1.0.seconds)
            XCTAssert(b1.state == .completed)
            XCTAssert(b2.state == .completed)
            XCTAssert(b3.state == .working)
        }
        do {
            manager.update(1.0.seconds)
            XCTAssert(b1.state == .completed)
            XCTAssert(b2.state == .completed)
            XCTAssert(b3.state == .completed)
        }
    }
    
    func testSequence() {
        let b1 = BlockAction(duration: 1.seconds)
        let b2 = BlockAction(duration: 1.seconds)
        let b3 = BlockAction(duration: 1.seconds)
        
        let manager = Manager()
        manager.run(
            SequenceAction(builder: {
                b1
                b2
                b3
            })
        )
        
        do {
            manager.update(0.5.seconds)
            XCTAssert(b1.state == .working)
            XCTAssert(b2.state == .idle)
            XCTAssert(b3.state == .idle)
        }
        do {
            manager.update(0.5.seconds)
            XCTAssert(b1.state == .completed)
            XCTAssert(b2.state == .working)
            XCTAssert(b3.state == .idle)
        }
        do {
            manager.update(1.0.seconds)
            XCTAssert(b1.state == .completed)
            XCTAssert(b2.state == .completed)
            XCTAssert(b3.state == .working)
        }
        do {
            manager.update(1.0.seconds)
            XCTAssert(b1.state == .completed)
            XCTAssert(b2.state == .completed)
            XCTAssert(b3.state == .completed)
        }
    }
    
}
