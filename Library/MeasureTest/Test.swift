//
//  KindKit-Test
//

import XCTest
import KindMeasure

class Test : XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        self.continueAfterFailure = false
    }
    
    func testAngle() {
        do {
            XCTAssert(equals: [
                Angle(value: 180, unit: .degree),
                Angle(value: .pi, unit: .radian),
                Angle(value: 0.5, unit: .turn)
            ])
        }
        do {
            XCTAssert(
                current: Angle(value: -90, unit: .degree),
                expected: Angle(value: -450, unit: .degree).validated
            )
            XCTAssert(
                current: Angle(value: 90, unit: .degree),
                expected: Angle(value: 450, unit: .degree).validated
            )
        }
    }
    
    func testLength() {
        do {
            XCTAssert(equals: [
                Length(value: 1, unit: .centimeter),
                Length(value: 10, unit: .millimeter)
            ])
        }
        do {
            XCTAssert(equals: [
                Length(value: 1, unit: .inch),
                Length(value: 25.4, unit: .millimeter)
            ])
        }
    }
    
    func testArea() {
        do {
            XCTAssert(
                current: Length(value: 3, unit: .centimeter) * Length(value: 4, unit: .centimeter),
                expected: Area(value: 12, unit: .centimeter)
            )
        }
    }
    
    func testVolume() {
        do {
            XCTAssert(
                current: Area(value: 12, unit: .centimeter) * Length(value: 2, unit: .centimeter),
                expected: Volume(value: 24, unit: .centimeter)
            )
        }
    }
    
    func testTime() throws {
        XCTAssert(
            current: Time(value: 1, unit: .day),
            expected: Time(value: 24, unit: .hour)
        )
        XCTAssert(
            current: Time(value: 1, unit: .hour),
            expected: Time(value: 60, unit: .minute)
        )
        XCTAssert(
            current: Time(value: 1, unit: .minute),
            expected: Time(value: 60, unit: .second)
        )
        XCTAssert(
            current: Time(value: 1, unit: .second),
            expected: Time(value: 1000, unit: .millisecond)
        )
        XCTAssert(
            current: Time(value: 1, unit: .millisecond),
            expected: Time(value: 1000, unit: .microsecond)
        )
        XCTAssert(
            current: Time(value: 1, unit: .microsecond),
            expected: Time(value: 1000, unit: .nanosecond)
        )
    }
    
}
