//
//  KindKit-Test
//

import XCTest
import KindTestUI

fileprivate func XCTAssertPath() -> Path? {
    guard let path = Path(String(#file)) else { return nil }
    guard let testCase = path.component(-3) else { return nil }
    return path.join("../../../../Snapshots/\(testCase)")
}

func XCTAssert(
    view: any IView,
    name: String,
    state: String,
    tolerance: CGFloat = 0.1,
    file: StaticString = #file,
    line: UInt = #line
) {
    guard let path = XCTAssertPath() else {
        XCTFail(file: file, line: line)
        return
    }
    XCTAssert(
        view: view,
        path: path.url,
        name: name,
        state: state,
        tolerance: tolerance,
        file: file,
        line: line
    )
}
