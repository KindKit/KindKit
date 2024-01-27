//
//  KindKit-Test
//

import XCTest
import KindUI

class TestTextView : XCTestCase {
    
    let baseStyle = Style()
        .fontFamily(.system)
        .fontSize(20)
    
    func testTextColor() {
        let style = Style()
            .inherit(self.baseStyle)
            .fontColor(.red)
        
        let view = TextView(.init("Text"))
            .width(.fixed(100))
            .height(.fixed(100))
            .style(style)
            .color(.black)
        
        do {
            XCTAssert(
                view: view,
                name: "Text",
                state: "TextColor/Red"
            )
        }
        do {
            style.fontColor(.blue)
            XCTAssert(
                view: view,
                name: "Text",
                state: "TextColor/Blue"
            )
        }
    }
    
    func testAlignment() {
        let style = Style()
            .inherit(self.baseStyle)
            .fontColor(.red)
            .alignment(.center)
        
        let view = TextView(.init("Text"))
            .width(.fixed(100))
            .height(.fixed(100))
            .style(style)
            .color(.black)
        
        do {
            style.alignment(.left)
            XCTAssert(
                view: view,
                name: "Text",
                state: "Alignment/Left"
            )
        }
        do {
            style.alignment(.center)
            XCTAssert(
                view: view,
                name: "Text",
                state: "Alignment/Center"
            )
        }
        do {
            style.alignment(.right)
            XCTAssert(
                view: view,
                name: "Text",
                state: "Alignment/Right"
            )
        }
    }
    
}
