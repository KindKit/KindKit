//
//  KindKit-Test
//

import XCTest
import KindJSON
import KindJSONMacro

class DateTest : XCTestCase {
    
    func testTimestamp() throws {
        let expected = Date.kk_make(year: 2024, month: 1, day: 1)!
        let representable = DateRepresentable.numberRepresentable(.unixtime)
        do {
            let json = try Document(string: "{\"field\":\"1704056400\"}")
            XCTAssert(try json.decode(Date.self, in: #Path("field"), with: .formats([ representable ])) == expected)
        }
        do {
            let json = Document()
            try json.encode(Date.self, value: expected, in: #Path("field"), with: .format(representable))
            XCTAssert(try json.decode(Date.self, in: #Path("field"), with: .formats([ representable ])) == expected)
        }
    }
    
    func testCustom() throws {
        let expected = Date.kk_make(year: 2024, month: 1, day: 1)!
        let representable = DateRepresentable.stringRepresentable(.init(format: "yyyy-MM-dd"))
        do {
            let json = try Document(string: "{\"field\":\"2024-01-01\"}")
            XCTAssert(try json.decode(Date.self, in: #Path("field"), with: .formats([ representable ])) == expected)
        }
        do {
            let json = Document()
            try json.encode(Date.self, value: expected, in: #Path("field"), with: .format(representable))
            XCTAssert(try json.decode(Date.self, in: #Path("field"), with: .formats([ representable ])) == expected)
        }
    }
    
}
