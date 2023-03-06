//
//  KindKit-Test
//

import XCTest
import KindKit

class TestStringInterpolation : XCTestCase {
    
    func testIfThen() {
        do {
            let str = "If\(if: true, then: " Then")"
            if str != "If Then" {
                XCTFail()
            }
        }
        do {
            let str = "If\(if: false, then: " Then")"
            if str != "If" {
                XCTFail()
            }
        }
    }
    
    func testIfThenElse() {
        do {
            let str = "If\(if: true, then: " Then", else: " Else")"
            if str != "If Then" {
                XCTFail()
            }
        }
        do {
            let str = "If\(if: false, then: " Then", else: " Else")"
            if str != "If Else" {
                XCTFail()
            }
        }
    }
    
    func testInteger() {
        let str = "Integer = \(1024, formatter: StringFormatter.Integer(usesGroupingSeparator: true, groupingSeparator: "_", groupingSize: 3))"
        if str != "Integer = 1_024" {
            XCTFail()
        }
    }
    
    func testFloat() {
        let str = "Float = \(1024.8, formatter: StringFormatter.Double(minFractionDigits: 0, maxFractionDigits: 8, decimalSeparator: "•", usesGroupingSeparator: true, groupingSeparator: "_", groupingSize: 3))"
        if str != "Float = 1_024•8" {
            XCTFail()
        }
    }
    
    func testDate() {
        let str = "Date = \(Date(timeIntervalSince1970: 0), formatter: StringFormatter.Date(format: "yyyy.MM.DD"))"
        if str != "Date = 1970.01.01" {
            XCTFail()
        }
    }

}
