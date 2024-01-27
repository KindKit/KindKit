//
//  KindKit-Test
//

import XCTest
import KindGeometry

class TestDistance2 : XCTestCase {
    
    func testPointToSegment2() {
        let p = Point(x: 0, y: 10)
        let s = Segment2(start: .init(x: 0, y: 0), end: .init(x: 10, y: 10))
        let result = KindGeometry.Distance2.find(p, s)
        XCTAssert(result.point.isNearEqual(p))
        XCTAssert(result.segment.point.isNearEqual(s.center))
    }
    
    func testLineToAlignedBox() {
        let l = Line2(origin: .init(x: 5, y: 5), angle: .degrees135)
        let b = AlignedBox2(lower: .init(x: 20, y: 20), upper: .init(x: 30, y: 30))
        let result = KindGeometry.Distance2.find(l, b)
        XCTAssert(result.line.point.isNearEqual(l.origin))
        XCTAssert(result.box.isNearEqual(b.topLeft))
    }
    
    func testPolylineToPolyline() {
        do {
            let p1 = Polyline2([
                .init(x: -100, y: -100),
                .init(x: -100, y: 100),
                .init(x: 100, y: 100),
                .init(x: 100, y: -100)
            ])
            let p2 = Polyline2([
                .init(x: -10, y: -10),
                .init(x: -10, y: 10),
                .init(x: 10, y: 10),
                .init(x: 10, y: -10)
            ])
            guard let result = KindGeometry.Distance2.find(p1, p2) else {
                XCTFail()
                return
            }
            XCTAssert(result.distance.isNearEqual(.init(value: 90)))
        }
        do {
            let p1 = Polyline2([
                .init(x: 0, y: 0),
                .init(x: 0, y: 100),
                .init(x: 100, y: 100),
                .init(x: 100, y: 0)
            ].reversed())
            let p2 = Polyline2([
                .init(x: 200, y: 0),
                .init(x: 200, y: 100),
                .init(x: 300, y: 100),
                .init(x: 300, y: 0)
            ])
            guard let result = KindGeometry.Distance2.find(p1, p2) else {
                XCTFail()
                return
            }
            XCTAssert(result.distance.isNearEqual(.init(value: 100)))
        }
    }
    
    func testPolylineToSegment() {
        let p = Polyline2([
            .init(x: -10, y: -10),
            .init(x: -10, y: 10),
            .init(x: 10, y: 10),
            .init(x: 10, y: -10)
        ])
        let s = Segment2(start: .init(x: 15, y: 10), end: .init(x: 10, y: 15))
        guard let result = KindGeometry.Distance2.find(p, s) else {
            XCTFail()
            return
        }
        XCTAssert(result.polyline.point.isNearEqual(.init(x: 10, y: 10)))
        XCTAssert(result.segment.point.isNearEqual(.init(x: 12.5, y: 12.5)))
    }
    
    func testSegmentToAlignedBox() {
        let s = Segment2(start: .init(x: 10, y: 0), end: .init(x: 0, y: 10))
        let b = AlignedBox2(lower: .init(x: 20, y: 20), upper: .init(x: 30, y: 30))
        let result = KindGeometry.Distance2.find(s, b)
        XCTAssert(result.segment.point.isNearEqual(s.center))
        XCTAssert(result.box.isNearEqual(b.topLeft))
    }
    
    func testSegmentToOrientedBox() {
        let s = Segment2(start: .init(x: 10, y: 0), end: .init(x: 0, y: 10))
        let b = OrientedBox2(shape: .init(lower: .init(x: 20, y: 20), upper: .init(x: 30, y: 30)), angle: .degrees45)
        let result = KindGeometry.Distance2.find(s, b)
        XCTAssert(result.segment.point.isNearEqual(s.start) || result.segment.point.isNearEqual(s.end))
        XCTAssert(result.box.isNearEqual(b.topLeft) || result.box.isNearEqual(b.topRight))
    }
    
}
