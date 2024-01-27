//
//  KindKit-Test
//

import XCTest
import KindUI

class TestLayoutView : XCTestCase {
    
    func test() {
        let view = LayoutView()
            .frame(.init(size: .init(width: 100, height: 90)))
            .content(
                VStackLayout(builder: {
                    ColorView().color(.red).height(.fixed(30))
                    ColorView().color(.green).height(.fixed(30))
                    ColorView().color(.blue).height(.fixed(30))
                })
            )
        
        XCTAssert(
            view: view,
            name: "Layout",
            state: "Base"
        )
    }
    
}
