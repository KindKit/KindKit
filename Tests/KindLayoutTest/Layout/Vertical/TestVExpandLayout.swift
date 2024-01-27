//
//  KindKit-Test
//

import XCTest
import KindLayout

final class TestVExpandLayout : XCTestCase {
    
    func test() {
        let layout = VExpandLayout(content: {
            StaticItem(width: .fixed(80), height: .fixed(20))
        }, detail: {
            StaticItem(width: .fixed(60), height: .fixed(40))
        })
        XCTAssert(
            layout: layout.state(.collapsed),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 80, height: 20),
            frames: [
                .init(x: 0, y: 0, width: 80, height: 20)
            ]
        )
        XCTAssert(
            layout: layout.state(.expanded),
            available: .fit,
            bounds: .init(width: 100, height: 100),
            size: .init(width: 80, height: 60),
            frames: [
                .init(x: 0, y: 0, width: 80, height: 20),
                .init(x: 0, y: 20, width: 60, height: 40)
            ]
        )
    }
    
}
