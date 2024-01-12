//
//  KindKit-Test
//

import XCTest
import KindKit

class TestIntersection2 : XCTestCase {
    
    func testPossiblyCircleToCircle() {
        let c1 = Circle(origin: Point(x: -1, y: 0), radius: Distance(1))
        let c2 = Circle(origin: Point(x: 1, y: 0), radius: Distance(2))
        
        let result = Math.Intersection2.possibly(c1, c2)
        if result == false {
            XCTFail()
        }
    }
    
    func testFindCircleToCircle() {
        let c1 = Circle(origin: Point(x: -1, y: 0), radius: Distance(2))
        let c2 = Circle(origin: Point(x: 1, y: 0), radius: Distance(2))
        
        let result = Math.Intersection2.find(c1, c2)
        switch result {
        case .two(let p1, let p2):
            if p1 !~ Point(x: 0, y: 1.7320508075688772) || p2 !~ Point(x: 0, y: -1.7320508075688772) {
                XCTFail()
            }
        default:
            XCTFail()
        }
    }
    
    func testPossiblyLineToLine() {
        let l1 = Line2(origin: Point(x: 0, y: 2), direction: Point(x: 1, y: 0))
        let l2 = Line2(origin: Point(x: 2, y: 0), direction: Point(x: 0, y: 1))
        
        let result = Math.Intersection2.possibly(l1, l2)
        if result == false {
            XCTFail()
        }
    }
    
    func testFindLineToLine() {
        let l1 = Line2(origin: Point(x: 0, y: 2), direction: Point(x: 1, y: 0))
        let l2 = Line2(origin: Point(x: 2, y: 0), direction: Point(x: 0, y: 1))
        
        let result = Math.Intersection2.find(l1, l2)
        switch result {
        case .point(let data):
            if data.point != Point(x: 2, y: 2) {
                XCTFail()
            }
        default:
            XCTFail()
        }
    }
    
    func testPossiblyLineToBox() {
        let l = Line2(origin: Point(x: 1, y: 1), direction: Point(x: 1, y: 0))
        let b = AlignedBox2(lower: Point(x: 0, y: 0), upper: Point(x: 2, y: 2))
        
        let result = Math.Intersection2.possibly(l, b)
        if result == false {
            XCTFail()
        }
    }
    
    func testFindLineToBox() {
        let l = Line2(origin: Point(x: 1, y: 1), direction: Point(x: 1, y: 0))
        let b = AlignedBox2(lower: Point(x: 0, y: 0), upper: Point(x: 2, y: 2))
        
        let result = Math.Intersection2.find(l, b)
        if result != .two(Point(x: 0, y: 1), Point(x: 2, y: 1)) {
            XCTFail()
        }
    }
    
    func testPossiblyLineToSegment() {
        let l = Line2(origin: Point(x: 0, y: 2), direction: Point(x: 1, y: 0))
        let s = Segment2(start: Point(x: 2, y: 0), end: Point(x: 2, y: 4))
        
        let result = Math.Intersection2.possibly(l, s)
        if result == false {
            XCTFail()
        }
    }
    
    func testFindLineToSegment() {
        let l = Line2(origin: Point(x: 0, y: 2), direction: Point(x: 1, y: 0))
        let s = Segment2(start: Point(x: 2, y: 0), end: Point(x: 2, y: 4))
        
        let result = Math.Intersection2.find(l, s)
        switch result {
        case .one(let point):
            if point != Point(x: 2, y: 2) {
                XCTFail()
            }
        default:
            XCTFail()
        }
    }
    
    func testPossiblySegmentToSegment() {
        let s1 = Segment2(start: Point(x: 0, y: 2), end: Point(x: 4, y: 2))
        let s2 = Segment2(start: Point(x: 2, y: 0), end: Point(x: 2, y: 4))
        
        let result = Math.Intersection2.possibly(s1, s2)
        if result == false {
            XCTFail()
        }
    }
    
    func testFindSegmentToSegment() {
        let s1 = Segment2(start: Point(x: 0, y: 2), end: Point(x: 4, y: 2))
        let s2 = Segment2(start: Point(x: 2, y: 0), end: Point(x: 2, y: 4))
        
        let result = Math.Intersection2.find(s1, s2)
        if result != .point(Point(x: 2, y: 2)) {
            XCTFail()
        }
    }
    
}
