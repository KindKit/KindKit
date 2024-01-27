//
//  KindKit-Test
//

import XCTest
import KindUI

class TestLayoutView : XCTestCase {
    
    func testRainbow() {
        do {
            let view = LayoutView(
                HStackLayout({
                    ColorView(.hex(rgb: 0xe81416)).width(.fixed(10))
                    ColorView(.hex(rgb: 0xffa500)).width(.fixed(10))
                    ColorView(.hex(rgb: 0xfaeb36)).width(.fixed(10))
                    ColorView(.hex(rgb: 0x79c314)).width(.fixed(10))
                    ColorView(.hex(rgb: 0x487de7)).width(.fixed(10))
                    ColorView(.hex(rgb: 0x4b369d)).width(.fixed(10))
                    ColorView(.hex(rgb: 0x70369d)).width(.fixed(10))
                })
            ).update(on: {
                $0.width = .fixed(70)
                $0.height = .fixed(100)
            })
            
            XCTAssert(
                view: view,
                name: "Layout",
                state: "Horizontal/Rainbow"
            )
        }
        do {
            let view = LayoutView(
                VStackLayout({
                    ColorView(.hex(rgb: 0xe81416)).height(.fixed(10))
                    ColorView(.hex(rgb: 0xffa500)).height(.fixed(10))
                    ColorView(.hex(rgb: 0xfaeb36)).height(.fixed(10))
                    ColorView(.hex(rgb: 0x79c314)).height(.fixed(10))
                    ColorView(.hex(rgb: 0x487de7)).height(.fixed(10))
                    ColorView(.hex(rgb: 0x4b369d)).height(.fixed(10))
                    ColorView(.hex(rgb: 0x70369d)).height(.fixed(10))
                })
            ).update(on: {
                $0.width = .fixed(100)
                $0.height = .fixed(70)
            })
            
            XCTAssert(
                view: view,
                name: "Layout",
                state: "Vertical/Rainbow"
            )
        }
    }
    
}
