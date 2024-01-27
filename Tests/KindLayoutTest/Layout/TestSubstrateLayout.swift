//
//  KindKit-Test
//

import XCTest
import KindLayout

final class TestSubstrateLayout : XCTestCase {
    
    func testBase() {
        XCTAssert(
            layout: SubstrateLayout()
                .content(
                    ItemLayout(
                        StaticItem(width: .fixed(20), height: .fixed(20))
                    )
                )
                .substrate(
                    MarginLayout()
                        .inset(.init(horizontal: 5, vertical: 5))
                        .content(ItemLayout(StaticItem(width: .fill, height: .fill)))
                ),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 20, height: 20),
            frames: [
                .init(x: 5, y: 5, width: 10, height: 10),
                .init(x: 0, y: 0, width: 20, height: 20)
            ]
        )
    }
    
    func testEmpty() {
        XCTAssert(
            layout: SubstrateLayout()
                .content(
                    NoneLayout()
                )
                .substrate(
                    MarginLayout()
                        .inset(.init(horizontal: 5, vertical: 5))
                        .content(ItemLayout(StaticItem(width: .fill, height: .fill)))
                ),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .zero
        )
    }
    
    func testHidden() {
        XCTAssert(
            layout: SubstrateLayout()
                .content(
                    ItemLayout(
                        StaticItem(width: .fixed(20), height: .fixed(20))
                            .isHidden(true)
                    )
                )
                .substrate(
                    MarginLayout()
                        .inset(.init(horizontal: 5, vertical: 5))
                        .content(ItemLayout(StaticItem(width: .fill, height: .fill)))
                ),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .zero
        )
    }
    
}
