//
//  KindKit-Test
//

import XCTest
import KindUI

class TestRectView : XCTestCase {
    
    func testFill() {
        let view = RectView(.red)
            .width(.fixed(100))
            .height(.fixed(100))
        
        do {
            XCTAssert(
                view: view,
                name: "Rect",
                state: "Fill/Red"
            )
        }
        
        do {
            view.color(.blue)
            
            XCTAssert(
                view: view,
                name: "Rect",
                state: "Fill/Blue"
            )
        }
    }
    
    func testCornerRadius() {
        let view = RectView(.red)
            .width(.fixed(100))
            .height(.fixed(100))
        
        do {
            view.cornerRadius(.manual(radius: 10))
            
            XCTAssert(
                view: view,
                name: "Rect",
                state: "Corner/Manual-10"
            )
        }
        do {
            view.cornerRadius(.auto)
            
            XCTAssert(
                view: view,
                name: "Rect",
                state: "Corner/Auto"
            )
        }
        do {
            view.cornerRadius(.auto(edges: [ .topLeft, .bottomRight ]))
            
            XCTAssert(
                view: view,
                name: "Rect",
                state: "Corner/Auto-TL-BR"
            )
        }
    }
    
}
