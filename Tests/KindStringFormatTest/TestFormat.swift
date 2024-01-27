//
//  KindKit-Test
//

import XCTest
import KindStringFormat

class TestFormat : XCTestCase {
    
    func test_IEEE_1003() {
        XCTAssert_IEEE_1003(
            format: "Signed number: %d",
            expected: "Signed number: 100",
            arguments: {
                IntegerArgument(100)
            }
        )
        XCTAssert_IEEE_1003(
            format: "Unsigned number: %u",
            expected: "Unsigned number: 100",
            arguments: {
                IntegerArgument(100)
            }
        )
        XCTAssert_IEEE_1003(
            format: "Floating point number: %.1f",
            expected: "Floating point number: 1.2",
            arguments: {
                FloatingPointArgument(1.19)
            }
        )
        XCTAssert_IEEE_1003(
            format: "Character UTF 8: %c",
            expected: "Character UTF 8: X",
            arguments: {
                StringArgument("X")
            }
        )
        XCTAssert_IEEE_1003(
            format: "Character UTF 16: %C",
            expected: "Character UTF 16: ®",
            arguments: {
                StringArgument("®")
            }
        )
        XCTAssert_IEEE_1003(
            format: "String UTF 8: %s",
            expected: "String UTF 8: Test X",
            arguments: {
                StringArgument("Test X")
            }
        )
        XCTAssert_IEEE_1003(
            format: "String UTF 16: %S",
            expected: "String UTF 16: Test ®",
            arguments: {
                StringArgument("Test ®")
            }
        )
        XCTAssert_IEEE_1003(
            format: "Object: %@",
            expected: "Object: 123",
            arguments: {
                StringArgument("123")
            }
        )
        XCTAssert_IEEE_1003(
            format: "Missing specifiers: %r %d",
            expected: "Missing specifiers: %r 1 2 3",
            arguments: {
                StringArgument("1 2 3")
            }
        )
        XCTAssert_IEEE_1003(
            format: "Placeholder: %%",
            expected: "Placeholder: %",
            arguments: {
            }
        )
        XCTAssert_IEEE_1003(
            format: "%d",
            expected: "1 2 3",
            arguments: {
                StringArgument("1 2 3")
            }
        )
    }
    
}

fileprivate func XCTAssert_IEEE_1003(
    format: String,
    expected: String,
    @ArgumentsBuilder arguments: () -> [IArgument],
    file: StaticString = #filePath,
    line: UInt = #line
) {
    let result = String.kk_build({
        FormatComponent(format: format, arguments: arguments)
    })
    if result != expected {
        XCTFail("Failure formatting '\(result)' expected \(expected)", file: file, line: line)
    }
}
