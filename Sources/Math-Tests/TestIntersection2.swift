//
//  KindKitMath-Test
//

import XCTest
@testable import KindKitMath

class TestIntersection2: XCTestCase {
    
    func testPossiblyCircleToCircle() {
        let c1 = CircleFloat(origin: Point(x: -1, y: 0), radius: 1)
        let c2 = CircleFloat(origin: Point(x: 1, y: 0), radius: 2)
        
        let result = Intersection2.possibly(c1, c2)
        if result == false {
            XCTFail()
        }
    }
    
    func testFindCircleToCircle() {
        let c1 = CircleFloat(origin: Point(x: -1, y: 0), radius: 2)
        let c2 = CircleFloat(origin: Point(x: 1, y: 0), radius: 2)
        
        let result = Intersection2.find(c1, c2)
        if result != .two(Point(x: 0, y: 1.73205078), Point(x: 0, y: -1.73205078)) {
            XCTFail()
        }
    }
    
    func testPossiblyLineToLine() {
        let l1 = Line2Float(origin: Point(x: 0, y: 2), direction: Point(x: 1, y: 0))
        let l2 = Line2Float(origin: Point(x: 2, y: 0), direction: Point(x: 0, y: 1))
        
        let result = Intersection2.possibly(l1, l2)
        if result == false {
            XCTFail()
        }
    }
    
    func testFindLineToLine() {
        let l1 = Line2Float(origin: Point(x: 0, y: 2), direction: Point(x: 1, y: 0))
        let l2 = Line2Float(origin: Point(x: 2, y: 0), direction: Point(x: 0, y: 1))
        
        let result = Intersection2.find(l1, l2)
        switch result {
        case .point(let data):
            if data.point != PointFloat(x: 2, y: 2) {
                XCTFail()
            }
        default:
            XCTFail()
        }
    }
    
    func testPossiblyLineToBox() {
        let l = Line2Float(origin: Point(x: 1, y: 1), direction: Point(x: 1, y: 0))
        let b = Box2Float(lower: Point(x: 0, y: 0), upper: Point(x: 2, y: 2))
        
        let result = Intersection2.possibly(l, b)
        if result == false {
            XCTFail()
        }
    }
    
    func testFindLineToBox() {
        let l = Line2Float(origin: Point(x: 1, y: 1), direction: Point(x: 1, y: 0))
        let b = Box2Float(lower: Point(x: 0, y: 0), upper: Point(x: 2, y: 2))
        
        let result = Intersection2.find(l, b)
        if result != .two(Point(x: 0, y: 1), Point(x: 2, y: 1)) {
            XCTFail()
        }
    }
    
    func testPossiblySegmentToSegment() {
        let s1 = Segment2Float(start: Point(x: 0, y: 2), end: Point(x: 4, y: 2))
        let s2 = Segment2Float(start: Point(x: 2, y: 0), end: Point(x: 2, y: 4))
        
        let result = Intersection2.possibly(s1, s2)
        if result == false {
            XCTFail()
        }
    }
    
    func testFindSegmentToSegment() {
        let s1 = Segment2Float(start: Point(x: 0, y: 2), end: Point(x: 4, y: 2))
        let s2 = Segment2Float(start: Point(x: 2, y: 0), end: Point(x: 2, y: 4))
        
        let result = Intersection2.find(s1, s2)
        if result != .one(PointFloat(x: 2, y: 2)) {
            XCTFail()
        }
    }
    
}
