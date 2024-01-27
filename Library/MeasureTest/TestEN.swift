//
//  KindKit-Test
//

import XCTest
import KindLocalize
import KindMeasure

class TestEN : XCTestCase {
    
    static let language = KindLocalize.Language.en
    
    override func setUp() {
        super.setUp()
        
        self.continueAfterFailure = false
    }
    
    func testAngle() {
        do {
            let a = Angle(value: 0.5, unit: .turn)
            XCTAssert(quantity: a, language: Self.language, unit: .degree, expected: [
                .symbol: "180 °",
                .abbreviation: "180 deg",
                .full: "180 degree"
            ])
            XCTAssert(quantity: a, language: Self.language, unit: .radian, expected: [
                .symbol: "3.14 R",
                .abbreviation: "3.14 rad",
                .full: "3.14 radian"
            ])
            XCTAssert(quantity: a, language: Self.language, unit: .turn, expected: [
                .symbol: "0.5 N",
                .abbreviation: "0.5 tr",
                .full: "0.5 turn"
            ])
        }
    }
    
    func testLength() {
        do {
            let l = Length(value: 1, unit: .centimeter)
            XCTAssert(quantity: l, language: Self.language, unit: .centimeter, expected: [
                .symbol: "1 cm",
                .abbreviation: "1 cm",
                .full: "1 centimeter"
            ])
            XCTAssert(quantity: l, language: Self.language, unit: .millimeter, expected: [
                .symbol: "10 mm",
                .abbreviation: "10 mm",
                .full: "10 millimeter"
            ])
            XCTAssert(quantity: l, language: Self.language, unit: .inch, expected: [
                .symbol: "0.39 \"",
                .abbreviation: "0.39 in",
                .full: "0.39 inch"
            ])
        }
    }
    
    func testArea() {
    }
    
    func testVolume() {
    }
    
}
