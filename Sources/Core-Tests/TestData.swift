//
//  KindKitCore-Test
//

import XCTest
@testable import KindKitCore

class TestData : XCTestCase {
    
    func testIsImage() {
        do {
            let data = Data([ 0x47, 0x49, 0x46, 0x38, 0x37, 0x61 ])
            if data.isGif == false {
                XCTFail("Invalid GIF signature")
            }
        }
        do {
            let data = Data([ 0xFF, 0xD8, 0xFF, 0xE1, 0x00, 0x00, 0x45, 0x78, 0x69, 0x66, 0x00, 0x00 ])
            if data.isJpeg == false {
                XCTFail("Invalid JPEG signature")
            }
        }
        do {
            let data = Data([ 0x52, 0x49, 0x46, 0x46, 0x00, 0x00, 0x00, 0x00, 0x57, 0x45, 0x42, 0x50 ])
            if data.isWebp == false {
                XCTFail("Invalid WebP signature")
            }
        }
    }

}
