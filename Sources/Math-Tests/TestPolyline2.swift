//
//  KindKitMath-Test
//

import XCTest
@testable import KindKitMath

class TestPolyline2: XCTestCase {
    
    func testExtrude1() {
        let op = Polyline2Float(corners: [
            PointFloat(x: 0, y: 0),
            PointFloat(x: 10, y: 0)
        ])
        let np = op.extrude(index: EdgeIndex(0), left: 0, right: 4.5, distance: 5)
        if np[corner: CornerIndex(0)] != PointFloat(x: 0, y: -5) {
            XCTFail()
        }
        if np[corner: CornerIndex(1)] != PointFloat(x: 4.5, y: -5) {
            XCTFail()
        }
        if np[corner: CornerIndex(2)] != PointFloat(x: 4.5, y: 0) {
            XCTFail()
        }
        if np[corner: CornerIndex(3)] != PointFloat(x: 10, y: 0) {
            XCTFail()
        }
    }
    
    func testExtrude2() {
        let op = Polyline2Float(corners: [
            PointFloat(x: 0, y: 0),
            PointFloat(x: 10, y: 0)
        ])
        let np = op.extrude(index: EdgeIndex(0), left: 5.5, right: 10, distance: 5)
        if np[corner: CornerIndex(0)] != PointFloat(x: 0, y: 0) {
            XCTFail()
        }
        if np[corner: CornerIndex(1)] != PointFloat(x: 5.5, y: 0) {
            XCTFail()
        }
        if np[corner: CornerIndex(2)] != PointFloat(x: 5.5, y: -5) {
            XCTFail()
        }
        if np[corner: CornerIndex(3)] != PointFloat(x: 10, y: -5) {
            XCTFail()
        }
    }
    
    func testExtrude3() {
        let op = Polyline2Float(corners: [
            PointFloat(x: 0, y: 0),
            PointFloat(x: 10, y: 0)
        ])
        let np = op.extrude(index: EdgeIndex(0), left: 2.5, right: 7.5, distance: 5)
        if np[corner: CornerIndex(0)] != PointFloat(x: 0, y: 0) {
            XCTFail()
        }
        if np[corner: CornerIndex(1)] != PointFloat(x: 2.5, y: 0) {
            XCTFail()
        }
        if np[corner: CornerIndex(2)] != PointFloat(x: 2.5, y: -5) {
            XCTFail()
        }
        if np[corner: CornerIndex(3)] != PointFloat(x: 7.5, y: -5) {
            XCTFail()
        }
        if np[corner: CornerIndex(4)] != PointFloat(x: 7.5, y: 0) {
            XCTFail()
        }
        if np[corner: CornerIndex(5)] != PointFloat(x: 10, y: 0) {
            XCTFail()
        }
    }
    
    func testBevel1() {
        let op = Polyline2Float(corners: [
            PointFloat(x: 0, y: 0),
            PointFloat(x: 20, y: 0),
            PointFloat(x: 20, y: 10),
            PointFloat(x: 0, y: 10)
        ])
        let np = op.bevel(index: CornerIndex(2), distance: 5)
        if np[corner: CornerIndex(2)] != PointFloat(x: 20, y: 5) {
            XCTFail()
        }
        if np[corner: CornerIndex(3)] != PointFloat(x: 15, y: 10) {
            XCTFail()
        }
    }
    
    func testBevel2() {
        let op = Polyline2Float(corners: [
            PointFloat(x: 0, y: 0),
            PointFloat(x: 20, y: 0),
            PointFloat(x: 20, y: 10),
            PointFloat(x: 0, y: 10)
        ])
        let np = op.bevel(index: CornerIndex(2), distance: 15)
        if np[corner: CornerIndex(1)] != PointFloat(x: 20, y: 0) {
            XCTFail()
        }
        if np[corner: CornerIndex(2)] != PointFloat(x: 10, y: 10) {
            XCTFail()
        }
    }
    
    func testCenter2() {
        let p = Polyline2Float(corners: [
            PointFloat(x: 0, y: 0),
            PointFloat(x: 20, y: 0),
            PointFloat(x: 20, y: 10),
            PointFloat(x: 0, y: 10)
        ])
        let center = p.center()
        if center != PointFloat(x: 10, y: 5) {
            XCTFail()
        }
    }
    
    func testPolylabel2() {
        let p = Polyline2Float(corners: [
            PointFloat(x: 0, y: 0),
            PointFloat(x: 20, y: 0),
            PointFloat(x: 20, y: 10),
            PointFloat(x: 0, y: 10)
        ])
        let center = p.visualCenter()
        if center != PointFloat(x: 10, y: 5) {
            XCTFail()
        }
    }

}
