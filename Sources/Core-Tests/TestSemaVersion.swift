//
//  KindKitCore-Test
//

import XCTest
@testable import KindKitCore

class TestSemaVersion : XCTestCase {
    
    func testFromStringMajorMinor() {
        guard let version = SemaVersion("1.1") else {
            XCTFail()
            return
        }
        if version.major != 1 {
            XCTFail()
        }
        if version.minor != 1 {
            XCTFail()
        }
    }
    
    func testFromStringMajorMinorPatch() {
        guard let version = SemaVersion("1.1.1") else {
            XCTFail()
            return
        }
        if version.major != 1 {
            XCTFail()
        }
        if version.minor != 1 {
            XCTFail()
        }
        if version.patch != 1 {
            XCTFail()
        }
    }

}
