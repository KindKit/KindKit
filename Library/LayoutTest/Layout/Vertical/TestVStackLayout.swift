//
//  KindKit-Test
//

import XCTest
import KindLayout

final class TestVStackLayout : XCTestCase {
    
    func testCollect() {
        XCTAssert(
            layout: VStackLayout({
                StaticItem(width: .fixed(80), height: .fixed(20))
                StaticItem(width: .fixed(60), height: .fixed(30))
                StaticItem(width: .fixed(40), height: .fixed(40))
            }).update(on: {
                $0.alignment = .left
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 80, height: 90),
            frames: [
                (
                    origin: .init(x: 0, y: 0),
                    frames: [
                        .init(x: 0, y: 0, width: 80, height: 20),
                        .init(x: 0, y: 20, width: 60, height: 30),
                        .init(x: 0, y: 50, width: 40, height: 40)
                    ]
                ), (
                    origin: .init(x: 0, y: 20),
                    frames: [
                        .init(x: 0, y: 20, width: 60, height: 30),
                        .init(x: 0, y: 50, width: 40, height: 40)
                    ]
                )
            ]
        )
    }
    
    func testAlignment() {
        XCTAssert(
            layout: VStackLayout({
                StaticItem(width: .fixed(80), height: .fixed(20))
                StaticItem(width: .fixed(60), height: .fixed(30))
                StaticItem(width: .fixed(40), height: .fixed(40))
            }).update(on: {
                $0.alignment = .left
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 80, height: 90),
            frames: [
                .init(x: 0, y: 0, width: 80, height: 20),
                .init(x: 0, y: 20, width: 60, height: 30),
                .init(x: 0, y: 50, width: 40, height: 40)
            ]
        )
        XCTAssert(
            layout: VStackLayout({
                StaticItem(width: .fixed(80), height: .fixed(20))
                StaticItem(width: .fixed(60), height: .fixed(30))
                StaticItem(width: .fixed(40), height: .fixed(40))
            }).update(on: {
                $0.alignment = .center
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 80, height: 90),
            frames: [
                .init(x: 0, y: 0, width: 80, height: 20),
                .init(x: 10, y: 20, width: 60, height: 30),
                .init(x: 20, y: 50, width: 40, height: 40)
            ]
        )
        XCTAssert(
            layout: VStackLayout({
                StaticItem(width: .fixed(80), height: .fixed(20))
                StaticItem(width: .fixed(60), height: .fixed(30))
                StaticItem(width: .fixed(40), height: .fixed(40))
            }).update(on: {
                $0.alignment = .right
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 80, height: 90),
            frames: [
                .init(x: 0, y: 0, width: 80, height: 20),
                .init(x: 20, y: 20, width: 60, height: 30),
                .init(x: 40, y: 50, width: 40, height: 40)
            ]
        )
    }
    
    func testSpacing() {
        XCTAssert(
            layout: VStackLayout({
                StaticItem(width: .fixed(80), height: .fixed(20))
                StaticItem(width: .fixed(60), height: .fixed(30))
                StaticItem(width: .fixed(40), height: .fixed(40))
            }).update(on: {
                $0.alignment = .left
                $0.spacing = 1
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 80, height: 92),
            frames: [
                .init(x: 0, y: 0, width: 80, height: 20),
                .init(x: 0, y: 21, width: 60, height: 30),
                .init(x: 0, y: 52, width: 40, height: 40)
            ]
        )
    }
    
    func testFit() {
        XCTAssert(
            layout: VStackLayout({
                DynamicItem(width: .fit, height: .fit, elementSize: .init(width: 10, height: 10), lines: [ 5 ])
                DynamicItem(width: .fit, height: .fit, elementSize: .init(width: 10, height: 10), lines: [ 10, 5 ])
                DynamicItem(width: .fit, height: .fit, elementSize: .init(width: 10, height: 10), lines: [ 2 ])
            }).update(on: {
                $0.alignment = .left
            }),
            available: .init(width: .fit, height: .fixed(35)),
            bounds: .init(width: 100, height: 100),
            size: .init(width: 100, height: 35),
            frames: [
                .init(x: 0, y: 0, width: 50, height: 10),
                .init(x: 0, y: 10, width: 100, height: 20),
                .init(x: 0, y: 30, width: 20, height: 5)
            ]
        )
    }
    
}
