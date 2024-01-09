//
//  KindKit-Test
//

import XCTest
import KindKit

class TestDistance2 : XCTestCase {
    
    func testPointToSegment2() {
        let p = Point(x: 0, y: 10)
        let s = Segment2(start: .init(x: 0, y: 0), end: .init(x: 10, y: 10))
        let result = Math.Distance2.find(p, s)
        XCTAssert(result.src ~~ p)
        XCTAssert(result.dst ~~ s.center)
    }
    
    func testLineToAlignedBox() {
        let l = Line2(origin: .init(x: 5, y: 5), angle: .degrees135)
        let b = AlignedBox2(lower: .init(x: 20, y: 20), upper: .init(x: 30, y: 30))
        let result = Math.Distance2.find(l, b)
        XCTAssert(result.src ~~ l.origin)
        XCTAssert(result.dst ~~ b.topLeft)
    }
    
    func testSegmentToAlignedBox() {
        let s = Segment2(start: .init(x: 10, y: 0), end: .init(x: 0, y: 10))
        let b = AlignedBox2(lower: .init(x: 20, y: 20), upper: .init(x: 30, y: 30))
        let result = Math.Distance2.find(s, b)
        XCTAssert(result.src ~~ s.center)
        XCTAssert(result.dst ~~ b.topLeft)
    }
    
    func testSegmentToOeintedBox() {
        let s = Segment2(start: .init(x: 10, y: 0), end: .init(x: 0, y: 10))
        let b = OrientedBox2(shape: .init(lower: .init(x: 20, y: 20), upper: .init(x: 30, y: 30)), angle: .degrees45)
        let result = Math.Distance2.find(s, b)
        XCTAssert(result.src ~~ s.start || result.src ~~ s.end)
        XCTAssert(result.dst ~~ b.topLeft || result.dst ~~ b.topRight)
    }
    
}
