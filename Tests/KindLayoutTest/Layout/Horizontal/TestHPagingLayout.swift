//
//  KindKit-Test
//

import XCTest
import KindLayout

final class TestHPagingLayout : XCTestCase {
    
    func testCollect() {
        XCTAssert(
            layout: HPagingLayout({
                StaticItem(width: .fixed(80), height: .fixed(20))
                StaticItem(width: .fixed(60), height: .fixed(30))
                StaticItem(width: .fixed(40), height: .fixed(40))
            }),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 300, height: 40),
            frames: [
                (
                    origin: .init(x: 0, y: 0),
                    frames: [
                        .init(x: 0, y: 0, width: 80, height: 20)
                    ]
                ), (
                    origin: .init(x: 50, y: 0),
                    frames: [
                        .init(x: 0, y: 0, width: 80, height: 20),
                        .init(x: 100, y: 0, width: 60, height: 30)
                    ]
                )
            ]
        )
    }
    
}
