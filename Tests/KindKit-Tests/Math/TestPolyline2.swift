//
//  KindKit-Test
//

import XCTest
import KindKit

class TestPolyline2 : XCTestCase {
    
    func testExtrude1() {
        let op = Polyline2(corners: [
            Point(x: 0, y: 0),
            Point(x: 10, y: 0)
        ])
        let np = op.extrude(index: EdgeIndex(0), left: Distance(0), right: Distance(4.5), distance: Distance(5))
        if np[corner: CornerIndex(1)] != Point(x: 0, y: -5) {
            XCTFail()
        }
        if np[corner: CornerIndex(2)] != Point(x: 4.5, y: -5) {
            XCTFail()
        }
        if np[corner: CornerIndex(3)] != Point(x: 4.5, y: 0) {
            XCTFail()
        }
        if np[corner: CornerIndex(4)] != Point(x: 10, y: 0) {
            XCTFail()
        }
    }
    
    func testExtrude2() {
        let op = Polyline2(corners: [
            Point(x: 0, y: 0),
            Point(x: 10, y: 0)
        ])
        let np = op.extrude(index: EdgeIndex(0), left: Distance(5.5), right: Distance(10), distance: Distance(5))
        if np[corner: CornerIndex(0)] != Point(x: 0, y: 0) {
            XCTFail()
        }
        if np[corner: CornerIndex(1)] != Point(x: 5.5, y: 0) {
            XCTFail()
        }
        if np[corner: CornerIndex(2)] != Point(x: 5.5, y: -5) {
            XCTFail()
        }
        if np[corner: CornerIndex(3)] != Point(x: 10, y: -5) {
            XCTFail()
        }
    }
    
    func testExtrude3() {
        let op = Polyline2(corners: [
            Point(x: 0, y: 0),
            Point(x: 10, y: 0)
        ])
        let np = op.extrude(index: EdgeIndex(0), left: Distance(2.5), right: Distance(7.5), distance: Distance(5))
        if np[corner: CornerIndex(0)] != Point(x: 0, y: 0) {
            XCTFail()
        }
        if np[corner: CornerIndex(1)] != Point(x: 2.5, y: 0) {
            XCTFail()
        }
        if np[corner: CornerIndex(2)] != Point(x: 2.5, y: -5) {
            XCTFail()
        }
        if np[corner: CornerIndex(3)] != Point(x: 7.5, y: -5) {
            XCTFail()
        }
        if np[corner: CornerIndex(4)] != Point(x: 7.5, y: 0) {
            XCTFail()
        }
        if np[corner: CornerIndex(5)] != Point(x: 10, y: 0) {
            XCTFail()
        }
    }
    
    func testBevel1() {
        let op = Polyline2(corners: [
            Point(x: 0, y: 0),
            Point(x: 20, y: 0),
            Point(x: 20, y: 10),
            Point(x: 0, y: 10)
        ])
        let np = op.bevel(index: CornerIndex(2), distance: Distance(5))
        if np[corner: CornerIndex(2)] != Point(x: 20, y: 5) {
            XCTFail()
        }
        if np[corner: CornerIndex(3)] != Point(x: 15, y: 10) {
            XCTFail()
        }
    }
    
    func testBevel2() {
        let op = Polyline2(corners: [
            Point(x: 0, y: 0),
            Point(x: 20, y: 0),
            Point(x: 20, y: 10),
            Point(x: 0, y: 10)
        ])
        let np = op.bevel(index: CornerIndex(2), distance: Distance(15))
        if np[corner: CornerIndex(1)] != Point(x: 20, y: 0) {
            XCTFail()
        }
        if np[corner: CornerIndex(2)] != Point(x: 10, y: 10) {
            XCTFail()
        }
    }
    
    func testCenter2() {
        let p = Polyline2(corners: [
            Point(x: 0, y: 0),
            Point(x: 20, y: 0),
            Point(x: 20, y: 10),
            Point(x: 0, y: 10)
        ])
        let center = p.center()
        if center != Point(x: 10, y: 5) {
            XCTFail()
        }
    }
    
    func testPolylabel2() {
        let p = Polyline2(corners: [
            Point(x: 0, y: 0),
            Point(x: 20, y: 0),
            Point(x: 20, y: 10),
            Point(x: 0, y: 10)
        ])
        let center = p.visualCenter()
        if center != Point(x: 10, y: 5) {
            XCTFail()
        }
    }

}
