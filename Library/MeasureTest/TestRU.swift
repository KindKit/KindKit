//
//  KindKit-Test
//

import XCTest
import KindLocalize
import KindMeasure

class TestRU : XCTestCase {
    
    static let language = KindLocalize.Language.ru
    
    override func setUp() {
        super.setUp()
        
        self.continueAfterFailure = false
    }
    
    func testAngle() {
        do {
            let a = Angle(value: 0.5, unit: .turn)
            XCTAssert(quantity: a, language: Self.language, unit: .degree, expected: [
                .symbol: "180 °",
                .abbreviation: "180 гр",
                .full: "180 градус"
            ])
            XCTAssert(quantity: a, language: Self.language, unit: .radian, expected: [
                .symbol: "3.14 R",
                .abbreviation: "3.14 рад",
                .full: "3.14 радиана"
            ])
            XCTAssert(quantity: a, language: Self.language, unit: .turn, expected: [
                .symbol: "0.5 N",
                .abbreviation: "0.5 об",
                .full: "0.5 оборот"
            ])
        }
    }
    
    func testLength() {
        do {
            let l = Length(value: 1, unit: .centimeter)
            XCTAssert(quantity: l, language: Self.language, unit: .centimeter, expected: [
                .symbol: "1 см",
                .abbreviation: "1 см",
                .full: "1 сантиметр"
            ])
            XCTAssert(quantity: l, language: Self.language, unit: .millimeter, expected: [
                .symbol: "10 мм",
                .abbreviation: "10 мм",
                .full: "10 миллиметр"
            ])
            XCTAssert(quantity: l, language: Self.language, unit: .inch, expected: [
                .symbol: "0.39 \"",
                .abbreviation: "0.39 дм",
                .full: "0.39 дюйм"
            ])
        }
    }
    
    func testArea() {
    }
    
    func testVolume() {
    }
    
}
