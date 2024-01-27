//
//  KindKit-Test
//

import XCTest
import KindLayout

final class TestVGridLayout : XCTestCase {
    
    func testHAlignment() {
        XCTAssert(
            layout: VGridLayout()
                .hAlignment(.left)
                .columns([ .auto, .auto ])
                .content([
                    ItemLayout(
                        StaticItem(width: .fixed(40), height: .fixed(20))
                    ),
                    ItemLayout(
                        StaticItem(width: .fixed(60), height: .fixed(30))
                    ),
                    ItemLayout(
                        StaticItem(width: .fixed(30), height: .fixed(40))
                    ),
                    ItemLayout(
                        StaticItem(width: .fixed(20), height: .fixed(50))
                    )
                ]),
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
            layout: VGridLayout()
                .hAlignment(.center)
                .columns([ .auto, .auto ])
                .content([
                    ItemLayout(
                        StaticItem(width: .fixed(40), height: .fixed(20))
                    ),
                    ItemLayout(
                        StaticItem(width: .fixed(60), height: .fixed(30))
                    ),
                    ItemLayout(
                        StaticItem(width: .fixed(30), height: .fixed(40))
                    ),
                    ItemLayout(
                        StaticItem(width: .fixed(20), height: .fixed(50))
                    )
                ]),
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
            layout: VGridLayout()
                .hAlignment(.right)
                .columns([ .auto, .auto ])
                .content([
                    ItemLayout(
                        StaticItem(width: .fixed(40), height: .fixed(20))
                    ),
                    ItemLayout(
                        StaticItem(width: .fixed(60), height: .fixed(30))
                    ),
                    ItemLayout(
                        StaticItem(width: .fixed(30), height: .fixed(40))
                    ),
                    ItemLayout(
                        StaticItem(width: .fixed(20), height: .fixed(50))
                    )
                ]),
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
            layout: VGridLayout()
                .vAlignment(.top)
                .columns([ .auto, .auto ])
                .content([
                    ItemLayout(
                        StaticItem(width: .fixed(40), height: .fixed(20))
                    ),
                    ItemLayout(
                        StaticItem(width: .fixed(60), height: .fixed(30))
                    ),
                    ItemLayout(
                        StaticItem(width: .fixed(30), height: .fixed(40))
                    ),
                    ItemLayout(
                        StaticItem(width: .fixed(20), height: .fixed(50))
                    )
                ]),
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
            layout: VGridLayout()
                .vAlignment(.center)
                .columns([ .auto, .auto ])
                .content([
                    ItemLayout(
                        StaticItem(width: .fixed(40), height: .fixed(20))
                    ),
                    ItemLayout(
                        StaticItem(width: .fixed(60), height: .fixed(30))
                    ),
                    ItemLayout(
                        StaticItem(width: .fixed(30), height: .fixed(40))
                    ),
                    ItemLayout(
                        StaticItem(width: .fixed(20), height: .fixed(50))
                    )
                ]),
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
            layout: VGridLayout()
                .vAlignment(.bottom)
                .columns([ .auto, .auto ])
                .content([
                    ItemLayout(
                        StaticItem(width: .fixed(40), height: .fixed(20))
                    ),
                    ItemLayout(
                        StaticItem(width: .fixed(60), height: .fixed(30))
                    ),
                    ItemLayout(
                        StaticItem(width: .fixed(30), height: .fixed(40))
                    ),
                    ItemLayout(
                        StaticItem(width: .fixed(20), height: .fixed(50))
                    )
                ]),
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
            layout: VGridLayout()
                .spacing(.init(x: 10, y: 5))
                .columns([ .auto, .auto ])
                .content([
                    ItemLayout(
                        StaticItem(width: .fixed(40), height: .fixed(20))
                    ),
                    ItemLayout(
                        StaticItem(width: .fixed(60), height: .fixed(30))
                    ),
                    ItemLayout(
                        StaticItem(width: .fixed(30), height: .fixed(40))
                    ),
                    ItemLayout(
                        StaticItem(width: .fixed(20), height: .fixed(50))
                    )
                ]),
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
