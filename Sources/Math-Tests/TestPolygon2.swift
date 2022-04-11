//
//  KindKitMath-Test
//

import XCTest
@testable import KindKitMath

class TestPolygon2: XCTestCase {
    
    func testExtrude1() {
        let op = Polygon2Float(corners: [
            PointFloat(x: 0, y: 0),
            PointFloat(x: 10, y: 0)
        ])
        let np = op.extrude(segment: 0, location: 0.2, distance: 5)
        if np[corner: 0] != PointFloat(x: 0, y: -5) {
            XCTFail()
        }
        if np[corner: 1] != PointFloat(x: 4.5, y: -5) {
            XCTFail()
        }
        if np[corner: 2] != PointFloat(x: 4.5, y: 0) {
            XCTFail()
        }
        if np[corner: 3] != PointFloat(x: 10, y: 0) {
            XCTFail()
        }
    }
    
    func testExtrude2() {
        let op = Polygon2Float(corners: [
            PointFloat(x: 0, y: 0),
            PointFloat(x: 10, y: 0)
        ])
        let np = op.extrude(segment: 0, location: 0.8, distance: 5)
        if np[corner: 0] != PointFloat(x: 0, y: 0) {
            XCTFail()
        }
        if np[corner: 1] != PointFloat(x: 5.5, y: 0) {
            XCTFail()
        }
        if np[corner: 2] != PointFloat(x: 5.5, y: -5) {
            XCTFail()
        }
        if np[corner: 3] != PointFloat(x: 10, y: -5) {
            XCTFail()
        }
    }
    
    func testExtrude3() {
        let op = Polygon2Float(corners: [
            PointFloat(x: 0, y: 0),
            PointFloat(x: 10, y: 0)
        ])
        let np = op.extrude(segment: 0, location: 0.5, distance: 5)
        if np[corner: 0] != PointFloat(x: 0, y: 0) {
            XCTFail()
        }
        if np[corner: 1] != PointFloat(x: 2.5, y: 0) {
            XCTFail()
        }
        if np[corner: 2] != PointFloat(x: 2.5, y: -5) {
            XCTFail()
        }
        if np[corner: 3] != PointFloat(x: 7.5, y: -5) {
            XCTFail()
        }
        if np[corner: 4] != PointFloat(x: 7.5, y: 0) {
            XCTFail()
        }
        if np[corner: 5] != PointFloat(x: 10, y: 0) {
            XCTFail()
        }
    }
    
    func testBevel1() {
        let op = Polygon2Float(corners: [
            PointFloat(x: 0, y: 0),
            PointFloat(x: 20, y: 0),
            PointFloat(x: 20, y: 10),
            PointFloat(x: 0, y: 10)
        ])
        let np = op.bevel(corner: 2, distance: 5)
        if np[corner: 2] != PointFloat(x: 20, y: 5) {
            XCTFail()
        }
        if np[corner: 3] != PointFloat(x: 15, y: 10) {
            XCTFail()
        }
    }
    
    func testBevel2() {
        let op = Polygon2Float(corners: [
            PointFloat(x: 0, y: 0),
            PointFloat(x: 20, y: 0),
            PointFloat(x: 20, y: 10),
            PointFloat(x: 0, y: 10)
        ])
        let np = op.bevel(corner: 2, distance: 15)
        if np[corner: 1] != PointFloat(x: 20, y: 0) {
            XCTFail()
        }
        if np[corner: 2] != PointFloat(x: 10, y: 10) {
            XCTFail()
        }
    }
    
}
