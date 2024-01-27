//
//  KindKit-Test
//

import XCTest
import KindLocalize
import KindMeasure

func XCTAssert< Value : Equatable >(
    current: Value,
    expected: Value,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    if current != expected {
        XCTFail("Failure '\(current)' expected \(expected)", file: file, line: line)
    }
}

func XCTAssert< Value : Equatable >(
    current: () -> Value,
    expected: () -> Value,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    XCTAssert(current: current(), expected: expected(), file: file, line: line)
}

func XCTAssert< Value : EpsilonTrait & NearEqualTrait >(
    current: Value,
    expected: Value,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    if current.isNearNotEqual(expected) {
        XCTFail("Failure '\(current)' expected \(expected)", file: file, line: line)
    }
}

func XCTAssert< Value : EpsilonTrait & NearEqualTrait >(
    current: () -> Value,
    expected: () -> Value,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    XCTAssert(current: current(), expected: expected(), file: file, line: line)
}

func XCTAssert< Quantity : KindMeasure.Quantity >(
    equals items: [Quantity],
    file: StaticString = #filePath,
    line: UInt = #line
) {
    for primaryIndex in items.indices {
        let primary = items[primaryIndex]
        for secondaryIndex in items.indices {
            guard primaryIndex != secondaryIndex else { continue }
            let secondary = items[secondaryIndex]
            XCTAssert(current: primary, expected: secondary, file: file, line: line)
        }
    }
}

func XCTAssert< Quantity : KindMeasure.Quantity >(
    quantity: Quantity,
    language: KindLocalize.Language = .system,
    unit: Quantity.Unit,
    expected: [Width : String],
    file: StaticString = #filePath,
    line: UInt = #line
) where Quantity.Unit.Finder == BundleFinder, Quantity.Unit.Value : BinaryFloatingPoint {
    let formatter = FloatingPointFormatter< Quantity >(unit)
        .finder(BundleFinder(
            bundle: Quantity.Unit.finder.bundle,
            table: Quantity.Unit.finder.table,
            language: language
        ))
        .decimalSeparator(".")
        .maxFractionDigits(2)
    for expected in expected {
        let formatted = formatter.width(expected.key).format(quantity)
        XCTAssert(current: formatted, expected: expected.value, file: file, line: line)
    }
}
