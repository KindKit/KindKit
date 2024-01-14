//
//  KindKit-Test
//

import XCTest
import KindCore

class TestSemaVersion : XCTestCase {
    
    func testFromStringZeroMajorMinor() {
        guard let version = SemaVersion("01.01") else {
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
    
    func testComparable() {
        do {
            guard let a = SemaVersion("1.1") else {
                XCTFail()
                return
            }
            guard let b = SemaVersion("1.1.1") else {
                XCTFail()
                return
            }
            if a == b {
                XCTFail()
            }
        }
        do {
            guard let a = SemaVersion("2.61.1") else {
                XCTFail()
                return
            }
            guard let b = SemaVersion("2.61.2") else {
                XCTFail()
                return
            }
            if a == b {
                XCTFail()
            }
        }
        do {
            guard let a = SemaVersion("2.61") else {
                XCTFail()
                return
            }
            guard let b = SemaVersion("2.61.2") else {
                XCTFail()
                return
            }
            if a > b {
                XCTFail()
            }
        }
    }

}
