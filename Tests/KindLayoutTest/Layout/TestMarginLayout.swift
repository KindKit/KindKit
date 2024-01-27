//
//  KindKit-Test
//

import XCTest
import KindLayout

final class TestMarginLayout : XCTestCase {
    
    func testBase() {
        XCTAssert(
            layout: MarginLayout({
                ItemLayout(
                    StaticItem(width: .fixed(20), height: .fixed(20))
                )
            }).update(on: {
                $0.inset = .init(horizontal: 10, vertical: 10)
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 40, height: 40),
            frames: [
                .init(x: 10, y: 10, width: 20, height: 20)
            ]
        )
    }
    
    func testEmpty() {
        XCTAssert(
            layout: MarginLayout().update(on: {
                $0.inset = .init(horizontal: 10, vertical: 10)
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .zero
        )
    }
    
    func testHidden() {
        XCTAssert(
            layout: MarginLayout({
                ItemLayout(
                    StaticItem(width: .fixed(20), height: .fixed(20)).isHidden(true)
                )
            }).update(on: {
                $0.inset = .init(horizontal: 10, vertical: 10)
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .zero
        )
    }
    
}
