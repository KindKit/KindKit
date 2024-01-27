//
//  KindKit-Test
//

import XCTest
import KindLayout

final class TestVPagingLayout : XCTestCase {
    
    func testCollect() {
        XCTAssert(
            layout: VPagingLayout({
                StaticItem(width: .fixed(20), height: .fixed(80))
                StaticItem(width: .fixed(30), height: .fixed(60))
                StaticItem(width: .fixed(40), height: .fixed(40))
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 40, height: 300),
            frames: [
                (
                    origin: .init(x: 0, y: 0),
                    frames: [
                        .init(x: 0, y: 0, width: 20, height: 80)
                    ]
                ), (
                    origin: .init(x: 0, y: 50),
                    frames: [
                        .init(x: 0, y: 0, width: 20, height: 80),
                        .init(x: 0, y: 100, width: 30, height: 60)
                    ]
                )
            ]
        )
    }
    
}
