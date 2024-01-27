//
//  KindKit-Test
//

import XCTest
import KindUIControl

class TestStackBarView : XCTestCase {
    
    let style = Style()
        .fontFamily(.system)
        .fontSize(20)
        .fontColor(.black)
        .alignment(.center)
    
    func testFixedTitle() {
        let background = ColorView(.white)
        
        let title = TextView(.init("Line 1"))
            .style(self.style)
            .color(.red)
        
        let bar = StackBarView(background: background, center: title)
            .width(.fixed(320))
            .height(.fixed(50))
            .inset(.init(top: 50, left: 8, right: 8, bottom: 0))
        
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
    
    func testFixedTitleTrailing() {
        let background = ColorView(.white)
        
        let title = TextView(.init("Line 1"))
            .style(self.style)
            .color(.red)
        
        let bar = StackBarView(background: background, center: title)
            .width(.fixed(320))
            .height(.fixed(50))
            .inset(.init(top: 50, left: 8, right: 8, bottom: 0))
            .trailings([
                RectView(.red)
                    .width(.fixed(44))
                    .height(.fixed(44))
                    .cornerRadius(.auto)
            ])
        
        do {
            XCTAssert(
                view: bar,
                name: "StackBarView",
                state: "Fixed/TitleTrailing"
            )
        }
    }
    
    func testFixedLeadingTitleTrailing() {
        let background = ColorView(.white)
        
        let title = TextView(.init("Line 1"))
            .style(self.style)
            .color(.red)
        
        let bar = StackBarView(background: background, center: title)
            .width(.fixed(320))
            .height(.fixed(50))
            .inset(.init(top: 50, left: 8, right: 8, bottom: 0))
            .background(background)
            .center(title)
            .leadings([
                RectView(.red)
                    .width(.fixed(44))
                    .height(.fixed(44))
                    .cornerRadius(.auto)
            ])
            .trailings([
                RectView(.red)
                    .width(.fixed(44))
                    .height(.fixed(44))
                    .cornerRadius(.auto)
            ])
        
        do {
            XCTAssert(
                view: bar,
                name: "StackBarView",
                state: "Fixed/LeadingTitleTrailing"
            )
        }
    }
    
    func testDynamicTitle() {
        let background = ColorView(.white)
        
        let title = TextView(.init("Line 1"))
            .style(self.style)
            .color(.red)
        
        let bar = StackBarView(background: background, center: title)
            .width(.fixed(320))
            .inset(.init(top: 50, left: 8, right: 8, bottom: 0))
        
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
