//
//  KindKit-Test
//

import XCTest
import KindLayout

final class TestCompositionLayout : XCTestCase {
    
    func testLogin() {
        let layout = VAccessoryLayout(center: {
            AlignmentLayout({
                VFitLayout(
                    VStackLayout({
                        StaticItem(width: .fill, height: .fixed(45))
                        StaticItem(width: .fill, height: .fixed(45))
                        VSpaceLayout(10)
                        StaticItem(width: .fill, height: .fixed(50))
                    })
                )
            }).update(on: {
                $0.vertical = .center
            })
        }, trailing: {
            StaticItem(width: .fill, height: .fixed(50))
        })
        XCTAssert(
            layout: layout,
            available: .fit,
            bounds: .init(width: 100, height: 300),
            size: .init(width: 100, height: 300),
            frames: [
                .init(x: 0, y: 250, width: 100, height: 50),
                .init(x: 0, y: 50, width: 100, height: 45),
                .init(x: 0, y: 95, width: 100, height: 45),
                .init(x: 0, y: 150, width: 100, height: 50)
            ]
        )
    }
    
}
