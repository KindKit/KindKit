//
//  KindKit-Test
//

import XCTest
import KindLayout

final class TestHStackLayout : XCTestCase {
    
    func testCollect() {
        XCTAssert(
            layout: HStackLayout({
                StaticItem(width: .fixed(20), height: .fixed(80))
                StaticItem(width: .fixed(30), height: .fixed(60))
                StaticItem(width: .fixed(40), height: .fixed(40))
            }).update(on: {
                $0.alignment = .top
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 90, height: 80),
            frames: [
                (
                    origin: .init(x: 0, y: 0),
                    frames: [
                        .init(x: 0, y: 0, width: 20, height: 80),
                        .init(x: 20, y: 0, width: 30, height: 60),
                        .init(x: 50, y: 0, width: 40, height: 40)
                    ]
                ), (
                    origin: .init(x: 20, y: 0),
                    frames: [
                        .init(x: 20, y: 0, width: 30, height: 60),
                        .init(x: 50, y: 0, width: 40, height: 40)
                    ]
                )
            ]
        )
    }
    
    func testAlignment() {
        XCTAssert(
            layout: HStackLayout({
                StaticItem(width: .fixed(20), height: .fixed(80))
                StaticItem(width: .fixed(30), height: .fixed(60))
                StaticItem(width: .fixed(40), height: .fixed(40))
            }).update(on: {
                $0.alignment = .top
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 90, height: 80),
            frames: [
                .init(x: 0, y: 0, width: 20, height: 80),
                .init(x: 20, y: 0, width: 30, height: 60),
                .init(x: 50, y: 0, width: 40, height: 40)
            ]
        )
        XCTAssert(
            layout: HStackLayout({
                StaticItem(width: .fixed(20), height: .fixed(80))
                StaticItem(width: .fixed(30), height: .fixed(60))
                StaticItem(width: .fixed(40), height: .fixed(40))
            }).update(on: {
                $0.alignment = .center
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 90, height: 80),
            frames: [
                .init(x: 0, y: 0, width: 20, height: 80),
                .init(x: 20, y: 10, width: 30, height: 60),
                .init(x: 50, y: 20, width: 40, height: 40)
            ]
        )
        XCTAssert(
            layout: HStackLayout({
                StaticItem(width: .fixed(20), height: .fixed(80))
                StaticItem(width: .fixed(30), height: .fixed(60))
                StaticItem(width: .fixed(40), height: .fixed(40))
            }).update(on: {
                $0.alignment = .bottom
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 90, height: 80),
            frames: [
                .init(x: 0, y: 0, width: 20, height: 80),
                .init(x: 20, y: 20, width: 30, height: 60),
                .init(x: 50, y: 40, width: 40, height: 40)
            ]
        )
    }
    
    func testAlignmentSpacing() {
        XCTAssert(
            layout: HStackLayout({
                StaticItem(width: .fixed(20), height: .fixed(80))
                StaticItem(width: .fixed(30), height: .fixed(60))
                StaticItem(width: .fixed(40), height: .fixed(40))
            }).update(on: {
                $0.alignment = .top
                $0.spacing = 1
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 92, height: 80),
            frames: [
                .init(x: 0, y: 0, width: 20, height: 80),
                .init(x: 21, y: 0, width: 30, height: 60),
                .init(x: 52, y: 0, width: 40, height: 40)
            ]
        )
    }
    
    func testFit() {
        XCTAssert(
            layout: HStackLayout({
                DynamicItem(width: .fit, height: .fit, elementSize: .init(width: 10, height: 10), lines: [ 1 ])
                DynamicItem(width: .fit, height: .fit, elementSize: .init(width: 10, height: 10), lines: [ 1, 2 ])
                DynamicItem(width: .fit, height: .fit, elementSize: .init(width: 10, height: 10), lines: [ 4 ])
            }).update(on: {
                $0.alignment = .top
            }),
            available: .init(width: .fixed(35), height: .fit),
            bounds: .init(width: 100, height: 100),
            size: .init(width: 35, height: 20),
            frames: [
                .init(x: 0, y: 0, width: 10, height: 10),
                .init(x: 10, y: 0, width: 20, height: 20),
                .init(x: 30, y: 0, width: 5, height: 10)
            ]
        )
    }
    
}
