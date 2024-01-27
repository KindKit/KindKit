//
//  KindKit-Test
//

import XCTest
import KindLayout

final class TestOverlayLayout : XCTestCase {
    
    func testBase() {
        XCTAssert(
            layout: OverlayLayout(content: {
                StaticItem(width: .fixed(20), height: .fixed(20))
            }, overlay: {
                MarginLayout({
                    StaticItem(width: .fill, height: .fill)
                }).update(on: {
                    $0.inset = .init(horizontal: 5, vertical: 5)
                })
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 20, height: 20),
            frames: [
                .init(x: 0, y: 0, width: 20, height: 20),
                .init(x: 5, y: 5, width: 10, height: 10)
            ]
        )
    }
    
    func testEmpty() {
        XCTAssert(
            layout: OverlayLayout(overlay: {
                MarginLayout({
                    StaticItem(width: .fill, height: .fill)
                }).update(on: {
                    $0.inset = .init(horizontal: 5, vertical: 5)
                })
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .zero
        )
    }
    
    func testHidden() {
        XCTAssert(
            layout: OverlayLayout(content: {
                StaticItem(width: .fixed(20), height: .fixed(20))
                    .isHidden(true)
            }, overlay: {
                MarginLayout({
                    StaticItem(width: .fill, height: .fill)
                }).update(on: {
                    $0.inset = .init(horizontal: 5, vertical: 5)
                })
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .zero
        )
    }
    
}
