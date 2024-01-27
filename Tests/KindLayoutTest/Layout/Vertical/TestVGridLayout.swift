//
//  KindKit-Test
//

import XCTest
import KindLayout

final class TestVGridLayout : XCTestCase {
    
    func testHAlignment() {
        XCTAssert(
            layout: VGridLayout({
                StaticItem(width: .fixed(40), height: .fixed(20))
                StaticItem(width: .fixed(60), height: .fixed(30))
                StaticItem(width: .fixed(30), height: .fixed(40))
                StaticItem(width: .fixed(20), height: .fixed(50))
            }).update(on: {
                $0.hAlignment = .left
                $0.columns = [ .auto, .auto ]
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 100, height: 80),
            frames: [
                .init(x: 0, y: 0, width: 40, height: 20),
                .init(x: 40, y: 0, width: 60, height: 30),
                .init(x: 0, y: 30, width: 30, height: 40),
                .init(x: 30, y: 30, width: 20, height: 50)
            ]
        )
        XCTAssert(
            layout: VGridLayout({
                StaticItem(width: .fixed(40), height: .fixed(20))
                StaticItem(width: .fixed(60), height: .fixed(30))
                StaticItem(width: .fixed(30), height: .fixed(40))
                StaticItem(width: .fixed(20), height: .fixed(50))
            }).update(on: {
                $0.hAlignment = .center
                $0.columns = [ .auto, .auto ]
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 100, height: 80),
            frames: [
                .init(x: 0, y: 0, width: 40, height: 20),
                .init(x: 40, y: 0, width: 60, height: 30),
                .init(x: 25, y: 30, width: 30, height: 40),
                .init(x: 55, y: 30, width: 20, height: 50)
            ]
        )
        XCTAssert(
            layout: VGridLayout({
                StaticItem(width: .fixed(40), height: .fixed(20))
                StaticItem(width: .fixed(60), height: .fixed(30))
                StaticItem(width: .fixed(30), height: .fixed(40))
                StaticItem(width: .fixed(20), height: .fixed(50))
            }).update(on: {
                $0.hAlignment = .right
                $0.columns = [ .auto, .auto ]
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 100, height: 80),
            frames: [
                .init(x: 0, y: 0, width: 40, height: 20),
                .init(x: 40, y: 0, width: 60, height: 30),
                .init(x: 50, y: 30, width: 30, height: 40),
                .init(x: 80, y: 30, width: 20, height: 50)
            ]
        )
    }
    
    func testVAlignment() {
        XCTAssert(
            layout: VGridLayout({
                StaticItem(width: .fixed(40), height: .fixed(20))
                StaticItem(width: .fixed(60), height: .fixed(30))
                StaticItem(width: .fixed(30), height: .fixed(40))
                StaticItem(width: .fixed(20), height: .fixed(50))
            }).update(on: {
                $0.vAlignment = .top
                $0.columns = [ .auto, .auto ]
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 100, height: 80),
            frames: [
                .init(x: 0, y: 0, width: 40, height: 20),
                .init(x: 40, y: 0, width: 60, height: 30),
                .init(x: 0, y: 30, width: 30, height: 40),
                .init(x: 30, y: 30, width: 20, height: 50)
            ]
        )
        XCTAssert(
            layout: VGridLayout({
                StaticItem(width: .fixed(40), height: .fixed(20))
                StaticItem(width: .fixed(60), height: .fixed(30))
                StaticItem(width: .fixed(30), height: .fixed(40))
                StaticItem(width: .fixed(20), height: .fixed(50))
            }).update(on: {
                $0.vAlignment = .center
                $0.columns = [ .auto, .auto ]
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 100, height: 80),
            frames: [
                .init(x: 0, y: 5, width: 40, height: 20),
                .init(x: 40, y: 0, width: 60, height: 30),
                .init(x: 0, y: 35, width: 30, height: 40),
                .init(x: 30, y: 30, width: 20, height: 50)
            ]
        )
        XCTAssert(
            layout: VGridLayout({
                StaticItem(width: .fixed(40), height: .fixed(20))
                StaticItem(width: .fixed(60), height: .fixed(30))
                StaticItem(width: .fixed(30), height: .fixed(40))
                StaticItem(width: .fixed(20), height: .fixed(50))
            }).update(on: {
                $0.vAlignment = .bottom
                $0.columns = [ .auto, .auto ]
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 100, height: 80),
            frames: [
                .init(x: 0, y: 10, width: 40, height: 20),
                .init(x: 40, y: 0, width: 60, height: 30),
                .init(x: 0, y: 40, width: 30, height: 40),
                .init(x: 30, y: 30, width: 20, height: 50)
            ]
        )
    }
    
    func testSpacing() {
        XCTAssert(
            layout: VGridLayout({
                StaticItem(width: .fixed(40), height: .fixed(20))
                StaticItem(width: .fixed(60), height: .fixed(30))
                StaticItem(width: .fixed(30), height: .fixed(40))
                StaticItem(width: .fixed(20), height: .fixed(50))
            }).update(on: {
                $0.spacing = .init(x: 10, y: 5)
                $0.columns = [ .auto, .auto ]
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 110, height: 85),
            frames: [
                .init(x: 0, y: 0, width: 40, height: 20),
                .init(x: 50, y: 0, width: 60, height: 30),
                .init(x: 0, y: 35, width: 30, height: 40),
                .init(x: 40, y: 35, width: 20, height: 50)
            ]
        )
    }
    
}
