//
//  KindKit-Test
//

import XCTest
import KindLayout

final class TestVFlowLayout : XCTestCase {
    
    func testHAlignment() {
        XCTAssert(
            layout: VFlowLayout({
                StaticItem(width: .fixed(80), height: .fixed(20))
                StaticItem(width: .fixed(60), height: .fixed(30))
                StaticItem(width: .fixed(40), height: .fixed(40))
            }).update(on: {
                $0.hAlignment = .left
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 100, height: 60),
            frames: [
                .init(x: 0, y: 0, width: 80, height: 20),
                .init(x: 0, y: 20, width: 60, height: 30),
                .init(x: 60, y: 20, width: 40, height: 40)
            ]
        )
        XCTAssert(
            layout: VFlowLayout({
                StaticItem(width: .fixed(80), height: .fixed(20))
                StaticItem(width: .fixed(60), height: .fixed(30))
                StaticItem(width: .fixed(40), height: .fixed(40))
            }).update(on: {
                $0.hAlignment = .center
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 100, height: 60),
            frames: [
                .init(x: 10, y: 0, width: 80, height: 20),
                .init(x: 0, y: 20, width: 60, height: 30),
                .init(x: 60, y: 20, width: 40, height: 40)
            ]
        )
        XCTAssert(
            layout: VFlowLayout({
                StaticItem(width: .fixed(80), height: .fixed(20))
                StaticItem(width: .fixed(60), height: .fixed(30))
                StaticItem(width: .fixed(40), height: .fixed(40))
            }).update(on: {
                $0.hAlignment = .right
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 100, height: 60),
            frames: [
                .init(x: 20, y: 0, width: 80, height: 20),
                .init(x: 0, y: 20, width: 60, height: 30),
                .init(x: 60, y: 20, width: 40, height: 40)
            ]
        )
    }
    
    func testVAlignment() {
        XCTAssert(
            layout: VFlowLayout({
                StaticItem(width: .fixed(80), height: .fixed(20))
                StaticItem(width: .fixed(60), height: .fixed(30))
                StaticItem(width: .fixed(40), height: .fixed(40))
            }).update(on: {
                $0.vAlignment = .top
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 100, height: 60),
            frames: [
                .init(x: 0, y: 0, width: 80, height: 20),
                .init(x: 0, y: 20, width: 60, height: 30),
                .init(x: 60, y: 20, width: 40, height: 40)
            ]
        )
        XCTAssert(
            layout: VFlowLayout({
                StaticItem(width: .fixed(80), height: .fixed(20))
                StaticItem(width: .fixed(60), height: .fixed(30))
                StaticItem(width: .fixed(40), height: .fixed(40))
            }).update(on: {
                $0.vAlignment = .center
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 100, height: 60),
            frames: [
                .init(x: 0, y: 0, width: 80, height: 20),
                .init(x: 0, y: 25, width: 60, height: 30),
                .init(x: 60, y: 20, width: 40, height: 40)
            ]
        )
        XCTAssert(
            layout: VFlowLayout({
                StaticItem(width: .fixed(80), height: .fixed(20))
                StaticItem(width: .fixed(60), height: .fixed(30))
                StaticItem(width: .fixed(40), height: .fixed(40))
            }).update(on: {
                $0.vAlignment = .bottom
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 100, height: 60),
            frames: [
                .init(x: 0, y: 0, width: 80, height: 20),
                .init(x: 0, y: 30, width: 60, height: 30),
                .init(x: 60, y: 20, width: 40, height: 40)
            ]
        )
    }
    
    func testSpacing() {
        XCTAssert(
            layout: VFlowLayout({
                StaticItem(width: .fixed(80), height: .fixed(20))
                StaticItem(width: .fixed(50), height: .fixed(30))
                StaticItem(width: .fixed(40), height: .fixed(40))
            }).update(on: {
                $0.itemSpacing = 10
                $0.lineSpacing = 5
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 100, height: 65),
            frames: [
                .init(x: 0, y: 0, width: 80, height: 20),
                .init(x: 0, y: 25, width: 50, height: 30),
                .init(x: 60, y: 25, width: 40, height: 40)
            ]
        )
    }
    
}
