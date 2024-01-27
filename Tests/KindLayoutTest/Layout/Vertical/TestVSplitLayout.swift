//
//  KindKit-Test
//

import XCTest
import KindLayout

final class TestVSplitLayout : XCTestCase {
    
    func testAlignment() {
        XCTAssert(
            layout: VSplitLayout({
                StaticItem(width: .fixed(80), height: .fill)
                StaticItem(width: .fixed(60), height: .fill)
                StaticItem(width: .fixed(40), height: .fill)
            }).update(on: {
                $0.alignment = .left
            }),
            available: .init(width: .fit, height: .fixed(90)),
            bounds: .init(width: 100, height: 100),
            size: .init(width: 80, height: 90),
            frames: [
                .init(x: 0, y: 0, width: 80, height: 30),
                .init(x: 0, y: 30, width: 60, height: 30),
                .init(x: 0, y: 60, width: 40, height: 30)
            ]
        )
        XCTAssert(
            layout: VSplitLayout({
                StaticItem(width: .fixed(80), height: .fill)
                StaticItem(width: .fixed(60), height: .fill)
                StaticItem(width: .fixed(40), height: .fill)
            }).update(on: {
                $0.alignment = .center
            }),
            available: .init(width: .fit, height: .fixed(90)),
            bounds: .init(width: 100, height: 100),
            size: .init(width: 80, height: 90),
            frames: [
                .init(x: 0, y: 0, width: 80, height: 30),
                .init(x: 10, y: 30, width: 60, height: 30),
                .init(x: 20, y: 60, width: 40, height: 30)
            ]
        )
        XCTAssert(
            layout: VSplitLayout({
                StaticItem(width: .fixed(80), height: .fill)
                StaticItem(width: .fixed(60), height: .fill)
                StaticItem(width: .fixed(40), height: .fill)
            }).update(on: {
                $0.alignment = .right
            }),
            available: .init(width: .fit, height: .fixed(90)),
            bounds: .init(width: 100, height: 100),
            size: .init(width: 80, height: 90),
            frames: [
                .init(x: 0, y: 0, width: 80, height: 30),
                .init(x: 20, y: 30, width: 60, height: 30),
                .init(x: 40, y: 60, width: 40, height: 30)
            ]
        )
    }
    
    func testSpacing() {
        XCTAssert(
            layout: VSplitLayout({
                StaticItem(width: .fixed(80), height: .fill)
                StaticItem(width: .fixed(60), height: .fill)
                StaticItem(width: .fixed(40), height: .fill)
            }).update(on: {
                $0.alignment = .left
                $0.spacing = 5
            }),
            available: .init(width: .fit, height: .fixed(100)),
            bounds: .init(width: 100, height: 100),
            size: .init(width: 80, height: 100),
            frames: [
                .init(x: 0, y: 0, width: 80, height: 30),
                .init(x: 0, y: 35, width: 60, height: 30),
                .init(x: 0, y: 70, width: 40, height: 30)
            ]
        )
    }
    
    func testSkipping() {
        XCTAssert(
            layout: VSplitLayout({
                StaticItem(width: .fixed(80), height: .fill)
                StaticItem(width: .fixed(60), height: .fill)
                    .isHidden(true)
                StaticItem(width: .fixed(40), height: .fill)
            }).update(on: {
                $0.alignment = .left
            }),
            available: .init(width: .fit, height: .fixed(90)),
            bounds: .init(width: 100, height: 100),
            size: .init(width: 80, height: 90),
            frames: [
                .init(x: 0, y: 0, width: 80, height: 45),
                .init(x: 0, y: 45, width: 40, height: 45)
            ]
        )
    }
    
}
