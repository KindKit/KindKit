//
//  KindKit-Test
//

import Testing
@testable import KindAnimation

struct Test {
    
    @Test
    func parallel() {
        let b1 = BlockAction(duration: 1.as(time: .second))
        let b2 = BlockAction(duration: 0.5.as(time: .second))
        let b3 = BlockAction(duration: 2.as(time: .second))
        
        let manager = Manager()
        manager.run(
            ParallelAction(builder: {
                b1
                b2
                b3
            })
        )
        
        do {
            manager.update(0.25.as(time: .second))
            #expect(b1.state == .working)
            #expect(b2.state == .working)
            #expect(b3.state == .working)
        }
        do {
            manager.update(0.5.as(time: .second))
            #expect(b1.state == .working)
            #expect(b2.state == .completed)
            #expect(b3.state == .working)
        }
        do {
            manager.update(1.0.as(time: .second))
            #expect(b1.state == .completed)
            #expect(b2.state == .completed)
            #expect(b3.state == .working)
        }
        do {
            manager.update(1.0.as(time: .second))
            #expect(b1.state == .completed)
            #expect(b2.state == .completed)
            #expect(b3.state == .completed)
        }
    }
    
    @Test
    func sequence() {
        let b1 = BlockAction(duration: 1.as(time: .second))
        let b2 = BlockAction(duration: 1.as(time: .second))
        let b3 = BlockAction(duration: 1.as(time: .second))
        
        let manager = Manager()
        manager.run(
            SequenceAction(builder: {
                b1
                b2
                b3
            })
        )
        
        do {
            manager.update(0.5.as(time: .second))
            #expect(b1.state == .working)
            #expect(b2.state == .idle)
            #expect(b3.state == .idle)
        }
        do {
            manager.update(0.5.as(time: .second))
            #expect(b1.state == .completed)
            #expect(b2.state == .working)
            #expect(b3.state == .idle)
        }
        do {
            manager.update(1.0.as(time: .second))
            #expect(b1.state == .completed)
            #expect(b2.state == .completed)
            #expect(b3.state == .working)
        }
        do {
            manager.update(1.0.as(time: .second))
            #expect(b1.state == .completed)
            #expect(b2.state == .completed)
            #expect(b3.state == .completed)
        }
    }
    
}
