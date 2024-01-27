//
//  KindKit-Test
//

import XCTest
import KindLayout

final class TestStaticSize : XCTestCase {
    
    func test() {
        let staticSize = StaticSize(width: .fixed(50), height: .fixed(50))
        let sizeRequest = SizeRequest(
            container: .init(width: 100, height: 100),
            available: .init(width: 80, height: 80)
        )
        let result = staticSize.resolve(by: sizeRequest)
        XCTAssert(result == .init(width: 50, height: 50))
    }
    
}
