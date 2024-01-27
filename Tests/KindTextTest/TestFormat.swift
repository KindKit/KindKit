//
//  KindKit-Test
//

import XCTest
import KindText

class TestFormat : XCTestCase {
    
    func test() {
        XCTAssert(
            format: "100 %d 100",
            expected: {
                var text = Text("100 100 100")
                text.set(options: .init(flags: .bold), in: .init(lower: 4, upper: 7))
                return text
            },
            arguments: {
                IntegerArgument(100, options: .init(flags: .bold))
            }
        )
        XCTAssert(
            format: "%3$s %2$d %1$.2f",
            expected: {
                var text = Text("100 200 300.00")
                text.set(options: .init(flags: .italic), in: .init(lower: 0, upper: 3))
                text.set(options: .init(flags: .bold), in: .init(lower: 4, upper: 7))
                text.set(options: .init(flags: .underline), in: .init(lower: 8, upper: 14))
                return text
            },
            arguments: {
                IntegerArgument(300, options: .init(flags: .underline))
                IntegerArgument(200, options: .init(flags: .bold))
                IntegerArgument(100, options: .init(flags: .italic))
            }
        )
    }
    
}

fileprivate func XCTAssert(
    format: String,
    expected: () -> Text,
    @ArgumentsBuilder arguments: () -> [IArgument],
    file: StaticString = #filePath,
    line: UInt = #line
) {
    let result = Text({
        FormatComponent(
            format: format,
            arguments: arguments
        )
    })
    let expected = expected()
    if result != expected {
        XCTFail("Failure formatting '\(result)' expected \(expected)", file: file, line: line)
    }
}
