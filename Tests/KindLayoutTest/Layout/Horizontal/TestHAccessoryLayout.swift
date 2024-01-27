//
//  KindKit-Test
//

import XCTest
import KindLayout

final class TestHAccessoryLayout : XCTestCase {
    
    func testLeadingCenter() {
        XCTAssert(
            layout: HAccessoryLayout()
                .leading(
                    ItemLayout(StaticItem(width: .fixed(20), height: .fixed(30)))
                )
                .center(
                    ItemLayout(StaticItem(width: .fixed(80), height: .fixed(20)))
                )
                .trailing(
                    NoneLayout()
                ),
            available: .init(width: .fixed(100), height: .fit),
            bounds: .init(width: 100, height: 100),
            size: .init(width: 100, height: 30),
            frames: [
                .init(x: 0, y: 0, width: 20, height: 30),
                .init(x: 20, y: 5, width: 80, height: 20)
            ]
        )
        XCTAssert(
            layout: HAccessoryLayout()
                .leading(
                    ItemLayout(StaticItem(width: .fixed(20), height: .fixed(30)))
                )
                .center(
                    ItemLayout(StaticItem(width: .fixed(80), height: .fixed(20)))
                )
                .trailing(
                    NoneLayout()
                ),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 100, height: 30),
            frames: [
                .init(x: 0, y: 0, width: 20, height: 30),
                .init(x: 20, y: 5, width: 80, height: 20)
            ]
        )
    }
    
    func testCenter() {
        XCTAssert(
            layout: HAccessoryLayout()
                .leading(
                    NoneLayout()
                )
                .center(
                    ItemLayout(StaticItem(width: .fill, height: .fixed(20)))
                )
                .trailing(
                    NoneLayout()
                ),
            available: .init(width: .fixed(100), height: .fit),
            bounds: .init(width: 100, height: 100),
            size: .init(width: 100, height: 20),
            frames: [
                .init(x: 0, y: 0, width: 100, height: 20)
            ]
        )
        XCTAssert(
            layout: HAccessoryLayout()
                .leading(
                    NoneLayout()
                )
                .center(
                    ItemLayout(StaticItem(width: .fill, height: .fixed(20)))
                )
                .trailing(
                    NoneLayout()
                ),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 100, height: 20),
            frames: [
                .init(x: 0, y: 0, width: 100, height: 20)
            ]
        )
    }
    
    func testCenterTrailing() {
        XCTAssert(
            layout: HAccessoryLayout()
                .leading(
                    NoneLayout()
                )
                .center(
                    ItemLayout(StaticItem(width: .fill, height: .fixed(20)))
                )
                .trailing(
                    ItemLayout(StaticItem(width: .fixed(20), height: .fixed(30)))
                ),
            available: .init(width: .fixed(100), height: .fit),
            bounds: .init(width: 100, height: 100),
            size: .init(width: 100, height: 30),
            frames: [
                .init(x: 80, y: 0, width: 20, height: 30),
                .init(x: 0, y: 5, width: 80, height: 20)
            ]
        )
        XCTAssert(
            layout: HAccessoryLayout()
                .leading(
                    NoneLayout()
                )
                .center(
                    ItemLayout(StaticItem(width: .fill, height: .fixed(20)))
                )
                .trailing(
                    ItemLayout(StaticItem(width: .fixed(20), height: .fixed(30)))
                ),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 100, height: 30),
            frames: [
                .init(x: 80, y: 0, width: 20, height: 30),
                .init(x: 0, y: 5, width: 80, height: 20)
            ]
        )
    }
    
    func testLeadingCenterTrailing() {
        XCTAssert(
            layout: HAccessoryLayout()
                .leading(
                    ItemLayout(StaticItem(width: .fixed(20), height: .fixed(30)))
                )
                .center(
                    ItemLayout(StaticItem(width: .fixed(60), height: .fixed(20)))
                )
                .trailing(
                    ItemLayout(StaticItem(width: .fixed(20), height: .fixed(30)))
                ),
            available: .init(width: .fixed(100), height: .fit),
            bounds: .init(width: 100, height: 100),
            size: .init(width: 100, height: 30),
            frames: [
                .init(x: 0, y: 0, width: 20, height: 30),
                .init(x: 80, y: 0, width: 20, height: 30),
                .init(x: 20, y: 5, width: 60, height: 20)
            ]
        )
        XCTAssert(
            layout: HAccessoryLayout()
                .leading(
                    ItemLayout(StaticItem(width: .fixed(20), height: .fixed(30)))
                )
                .center(
                    ItemLayout(StaticItem(width: .fixed(60), height: .fixed(20)))
                )
                .trailing(
                    ItemLayout(StaticItem(width: .fixed(20), height: .fixed(30)))
                ),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 100, height: 30),
            frames: [
                .init(x: 0, y: 0, width: 20, height: 30),
                .init(x: 80, y: 0, width: 20, height: 30),
                .init(x: 20, y: 5, width: 60, height: 20)
            ]
        )
    }
    
}
