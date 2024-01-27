//
//  KindKit-Test
//

import XCTest
import KindLayout

final class TestVAccessoryLayout : XCTestCase {
    
    func testLeadingCenter() {
        XCTAssert(
            layout: VAccessoryLayout()
                .leading(
                    ItemLayout(StaticItem(width: .fixed(30), height: .fixed(20)))
                )
                .center(
                    ItemLayout(StaticItem(width: .fixed(20), height: .fixed(80)))
                )
                .trailing(
                    NoneLayout()
                ),
            available: .init(width: .fit, height: .fixed(100)),
            bounds: .init(width: 100, height: 100),
            size: .init(width: 30, height: 100),
            frames: [
                .init(x: 0, y: 0, width: 30, height: 20),
                .init(x: 5, y: 20, width: 20, height: 80)
            ]
        )
        XCTAssert(
            layout: VAccessoryLayout()
                .leading(
                    ItemLayout(StaticItem(width: .fixed(30), height: .fixed(20)))
                )
                .center(
                    ItemLayout(StaticItem(width: .fixed(20), height: .fixed(80)))
                )
                .trailing(
                    NoneLayout()
                ),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 30, height: 100),
            frames: [
                .init(x: 0, y: 0, width: 30, height: 20),
                .init(x: 5, y: 20, width: 20, height: 80)
            ]
        )
    }
    
    func testCenter() {
        XCTAssert(
            layout: VAccessoryLayout()
                .leading(
                    NoneLayout()
                )
                .center(
                    ItemLayout(StaticItem(width: .fixed(20), height: .fill))
                )
                .trailing(
                    NoneLayout()
                ),
            available: .init(width: .fit, height: .fixed(100)),
            bounds: .init(width: 100, height: 100),
            size: .init(width: 20, height: 100),
            frames: [
                .init(x: 0, y: 0, width: 20, height: 100)
            ]
        )
        XCTAssert(
            layout: VAccessoryLayout()
                .leading(
                    NoneLayout()
                )
                .center(
                    ItemLayout(StaticItem(width: .fixed(20), height: .fill))
                )
                .trailing(
                    NoneLayout()
                ),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 20, height: 100),
            frames: [
                .init(x: 0, y: 0, width: 20, height: 100)
            ]
        )
    }
    
    func testCenterTrailing() {
        XCTAssert(
            layout: VAccessoryLayout()
                .leading(
                    NoneLayout()
                )
                .center(
                    ItemLayout(StaticItem(width: .fixed(20), height: .fixed(80)))
                )
                .trailing(
                    ItemLayout(StaticItem(width: .fixed(30), height: .fixed(20)))
                ),
            available: .init(width: .fit, height: .fixed(100)),
            bounds: .init(width: 100, height: 100),
            size: .init(width: 30, height: 100),
            frames: [
                .init(x: 0, y: 80, width: 30, height: 20),
                .init(x: 5, y: 0, width: 20, height: 80)
            ]
        )
        XCTAssert(
            layout: VAccessoryLayout()
                .leading(
                    NoneLayout()
                )
                .center(
                    ItemLayout(StaticItem(width: .fixed(20), height: .fixed(80)))
                )
                .trailing(
                    ItemLayout(StaticItem(width: .fixed(30), height: .fixed(20)))
                ),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 30, height: 100),
            frames: [
                .init(x: 0, y: 80, width: 30, height: 20),
                .init(x: 5, y: 0, width: 20, height: 80)
            ]
        )
    }
    
    func testLeadingCenterTrailing() {
        XCTAssert(
            layout: VAccessoryLayout()
                .leading(
                    ItemLayout(StaticItem(width: .fixed(30), height: .fixed(20)))
                )
                .center(
                    ItemLayout(StaticItem(width: .fixed(20), height: .fixed(60)))
                )
                .trailing(
                    ItemLayout(StaticItem(width: .fixed(30), height: .fixed(20)))
                ),
            available: .init(width: .fit, height: .fixed(100)),
            bounds: .init(width: 100, height: 100),
            size: .init(width: 30, height: 100),
            frames: [
                .init(x: 0, y: 0, width: 30, height: 20),
                .init(x: 0, y: 80, width: 30, height: 20),
                .init(x: 5, y: 20, width: 20, height: 60)
            ]
        )
        XCTAssert(
            layout: VAccessoryLayout()
                .leading(
                    ItemLayout(StaticItem(width: .fixed(30), height: .fixed(20)))
                )
                .center(
                    ItemLayout(StaticItem(width: .fixed(20), height: .fixed(60)))
                )
                .trailing(
                    ItemLayout(StaticItem(width: .fixed(30), height: .fixed(20)))
                ),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 30, height: 100),
            frames: [
                .init(x: 0, y: 0, width: 30, height: 20),
                .init(x: 0, y: 80, width: 30, height: 20),
                .init(x: 5, y: 20, width: 20, height: 60)
            ]
        )
    }
    
}
