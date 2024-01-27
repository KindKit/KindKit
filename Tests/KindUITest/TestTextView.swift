//
//  KindKit-Test
//

import XCTest
import KindUI

class TestTextView : XCTestCase {
    
    func test() {
        let style = Style(inherit: .default)
            .fontFamily(.system)
            .fontSize(10)
            .fontColor(.red)
        
        let view = TextView()
            .frame(.init(size: .init(width: 100, height: 90)))
            .style(style)
            .text(.init("Test"))
            .color(.black)
        
        XCTAssert(
            view: view,
            name: "Text",
            state: "Base"
        )
    }
    
}
