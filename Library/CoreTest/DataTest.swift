//
//  KindKit-Test
//

import Foundation
import Testing
import KindCore

struct TestData {
    
    @Test
    func isImage() {
        do {
            let data = Data([ 0x47, 0x49, 0x46, 0x38, 0x37, 0x61 ])
            if data.kk_isGif == false {
                Issue.record("Invalid GIF signature")
            }
        }
        do {
            let data = Data([ 0xFF, 0xD8, 0xFF, 0xE1, 0x00, 0x00, 0x45, 0x78, 0x69, 0x66, 0x00, 0x00 ])
            if data.kk_isJpeg == false {
                Issue.record("Invalid JPEG signature")
            }
        }
        do {
            let data = Data([ 0x52, 0x49, 0x46, 0x46, 0x00, 0x00, 0x00, 0x00, 0x57, 0x45, 0x42, 0x50 ])
            if data.kk_isWebp == false {
                Issue.record("Invalid WebP signature")
            }
        }
    }

}
