//
//  KindKit-Test
//

import XCTest
import KindLayout

final class TestHSplitLayout : XCTestCase {
    
    func testAlignment() {
        XCTAssert(
            layout: HSplitLayout({
                StaticItem(width: .fill, height: .fixed(80))
                StaticItem(width: .fill, height: .fixed(60))
                StaticItem(width: .fill, height: .fixed(40))
            }).update(on: {
                $0.alignment = .top
            }),
            available: .init(width: .fixed(90), height: .fit),
            bounds: .init(width: 100, height: 100),
            size: .init(width: 90, height: 80),
            frames: [
                .init(x: 0, y: 0, width: 30, height: 80),
                .init(x: 30, y: 0, width: 30, height: 60),
                .init(x: 60, y: 0, width: 30, height: 40)
            ]
        )
        XCTAssert(
            layout: HSplitLayout({
                StaticItem(width: .fill, height: .fixed(80))
                StaticItem(width: .fill, height: .fixed(60))
                StaticItem(width: .fill, height: .fixed(40))
            }).update(on: {
                $0.alignment = .center
            }),
            available: .init(width: .fixed(90), height: .fit),
            bounds: .init(width: 100, height: 100),
            size: .init(width: 90, height: 80),
            frames: [
                .init(x: 0, y: 0, width: 30, height: 80),
                .init(x: 30, y: 10, width: 30, height: 60),
                .init(x: 60, y: 20, width: 30, height: 40)
            ]
        )
        XCTAssert(
            layout: HSplitLayout({
                StaticItem(width: .fill, height: .fixed(80))
                StaticItem(width: .fill, height: .fixed(60))
                StaticItem(width: .fill, height: .fixed(40))
            }).update(on: {
                $0.alignment = .bottom
            }),
            available: .init(width: .fixed(90), height: .fit),
            bounds: .init(width: 100, height: 100),
            size: .init(width: 90, height: 80),
            frames: [
                .init(x: 0, y: 0, width: 30, height: 80),
                .init(x: 30, y: 20, width: 30, height: 60),
                .init(x: 60, y: 40, width: 30, height: 40)
            ]
        )
    }
    
    func testSpacing() {
        XCTAssert(
            layout: HSplitLayout({
                StaticItem(width: .fill, height: .fixed(80))
                StaticItem(width: .fill, height: .fixed(60))
                StaticItem(width: .fill, height: .fixed(40))
            }).update(on: {
                $0.alignment = .top
                $0.spacing = 5
            }),
            available: .init(width: .fixed(100), height: .fit),
            bounds: .init(width: 100, height: 100),
            size: .init(width: 100, height: 80),
            frames: [
                .init(x: 0, y: 0, width: 30, height: 80),
                .init(x: 35, y: 0, width: 30, height: 60),
                .init(x: 70, y: 0, width: 30, height: 40)
            ]
        )
    }
    
    func testSkipping() {
        XCTAssert(
            layout: HSplitLayout({
                StaticItem(width: .fill, height: .fixed(80))
                StaticItem(width: .fill, height: .fixed(60))
                    .isHidden(true)
                StaticItem(width: .fill, height: .fixed(40))
            }).update(on: {
                $0.alignment = .top
            }),
            available: .init(width: .fixed(90), height: .fit),
            bounds: .init(width: 100, height: 100),
            size: .init(width: 90, height: 80),
            frames: [
                .init(x: 0, y: 0, width: 45, height: 80),
                .init(x: 45, y: 0, width: 45, height: 40)
            ]
        )
    }
    
}
