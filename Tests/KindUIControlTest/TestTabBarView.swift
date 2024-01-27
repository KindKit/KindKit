//
//  KindKit-Test
//

import XCTest
import KindUIControl
/*
class TestTabBarView : XCTestCase {
    
    let style = Style()
        .fontFamily(.system)
        .fontSize(20)
        .fontColor(.black)
        .alignment(.center)
    
    func testFixedTitle() {
        let background = ColorView()
            .color(.white)
        
        let title = TextView()
            .style(self.style)
            .text(.init("Line 1"))
            .color(.red)
        
        let bar = TabBarView< ColorView, RectView, ColorView >()
            .width(.fixed(320))
            .height(.fixed(50))
            .inset(.init(top: 50, left: 8, right: 8, bottom: 0))
            .background(background)
            .center(title)
        
        do {
            XCTAssert(
                view: bar,
                name: "StackBarView",
                state: "Fixed/Title/Line-1"
            )
        }
        
        do {
            title.text = .init("Line 1\nLine 2")
            
            XCTAssert(
                view: bar,
                name: "StackBarView",
                state: "Fixed/Title/Line-2"
            )
        }
        
        do {
            title.text = .init("Line 1\nLine 2\nLine 3")
            
            XCTAssert(
                view: bar,
                name: "StackBarView",
                state: "Fixed/Title/Line-3"
            )
        }
    }
    
    func testDynamicTitle() {
        let background = ColorView()
            .color(.white)
        
        let title = TextView()
            .style(self.style)
            .text(.init("Line 1"))
            .color(.red)
        
        let bar = StackBarView< ColorView, ColorView, TextView, ColorView, ColorView >()
            .width(.fixed(320))
            .inset(.init(top: 50, left: 8, right: 8, bottom: 0))
            .background(background)
            .center(title)
        
        do {
            XCTAssert(
                view: bar,
                name: "StackBarView",
                state: "Dynamic/Title/Line-1"
            )
        }
        
        do {
            bar.lockLayout()
            title.text = .init("Line 1\nLine 2")
            bar.unlockLayout()
            
            XCTAssert(
                view: bar,
                name: "StackBarView",
                state: "Dynamic/Title/Line-2"
            )
        }
        
        do {
            title.text = .init("Line 1\nLine 2\nLine 3")
            
            XCTAssert(
                view: bar,
                name: "StackBarView",
                state: "Dynamic/Title/Line-3"
            )
        }
    }
    
}
*/
