//
//  KindKit-Test
//

import XCTest
import KindStringFormat

class TestSpecifier : XCTestCase {
    
    func test_IEEE_1003() {
        do { // Placeholder
            XCTAssert(
                format: "%%",
                specifier: .placeholder
            )
        }
        do { // Char
            XCTAssert(
                format: "%c",
                specifier: .init(index: .auto, info: .char())
            )
            XCTAssert(
                format: "%-c",
                specifier: .init(index: .auto, info: .char(alignment: .left))
            )
            XCTAssert(
                format: "%3c",
                specifier: .init(index: .auto, info: .char(width: .fixed(3)))
            )
            XCTAssert(
                format: "%C",
                specifier: .init(index: .auto, info: .char(length: .utf16))
            )
            XCTAssert(
                format: "%-C",
                specifier: .init(index: .auto, info: .char(alignment: .left, length: .utf16))
            )
            XCTAssert(
                format: "%3C",
                specifier: .init(index: .auto, info: .char(width: .fixed(3), length: .utf16))
            )
        }
        do { // String
            XCTAssert(
                format: "%s",
                specifier: .init(index: .auto, info: .string())
            )
            XCTAssert(
                format: "%-s",
                specifier: .init(index: .auto, info: .string(alignment: .left))
            )
            XCTAssert(
                format: "%3s",
                specifier: .init(index: .auto, info: .string(width: .fixed(3)))
            )
            XCTAssert(
                format: "%S",
                specifier: .init(index: .auto, info: .string(length: .utf16))
            )
            XCTAssert(
                format: "%-S",
                specifier: .init(index: .auto, info: .string(alignment: .left, length: .utf16))
            )
            XCTAssert(
                format: "%3S",
                specifier: .init(index: .auto, info: .string(width: .fixed(3), length: .utf16))
            )
        }
        do { // Signed number
            XCTAssert(
                format: "%d",
                specifier: .init(index: .auto, info: .numberSigned())
            )
            XCTAssert(
                format: "%-d",
                specifier: .init(index: .auto, info: .numberSigned(alignment: .left))
            )
            XCTAssert(
                format: "%+d",
                specifier: .init(index: .auto, info: .numberSigned(flags: .sign))
            )
            XCTAssert(
                format: "%0d",
                specifier: .init(index: .auto, info: .numberSigned(flags: .zero))
            )
            XCTAssert(
                format: "%3d",
                specifier: .init(index: .auto, info: .numberSigned(width: .fixed(3)))
            )
            XCTAssert(
                format: "%hhd",
                specifier: .init(index: .auto, info: .numberSigned(length: .char))
            )
            XCTAssert(
                format: "%hd",
                specifier: .init(index: .auto, info: .numberSigned(length: .short))
            )
            XCTAssert(
                format: "%ld",
                specifier: .init(index: .auto, info: .numberSigned(length: .long))
            )
            XCTAssert(
                format: "%lld",
                specifier: .init(index: .auto, info: .numberSigned(length: .longLong))
            )
        }
        do { // Unsigned number
            XCTAssert(
                format: "%u",
                specifier: .init(index: .auto, info: .numberUnsigned())
            )
            XCTAssert(
                format: "%-u",
                specifier: .init(index: .auto, info: .numberUnsigned(alignment: .left))
            )
            XCTAssert(
                format: "%0u",
                specifier: .init(index: .auto, info: .numberUnsigned(flags: .zero))
            )
            XCTAssert(
                format: "%3u",
                specifier: .init(index: .auto, info: .numberUnsigned(width: .fixed(3)))
            )
            XCTAssert(
                format: "%hhu",
                specifier: .init(index: .auto, info: .numberUnsigned(length: .char))
            )
            XCTAssert(
                format: "%hu",
                specifier: .init(index: .auto, info: .numberUnsigned(length: .short))
            )
            XCTAssert(
                format: "%lu",
                specifier: .init(index: .auto, info: .numberUnsigned(length: .long))
            )
            XCTAssert(
                format: "%llu",
                specifier: .init(index: .auto, info: .numberUnsigned(length: .longLong))
            )
        }
        do { // Floating point
            XCTAssert(
                format: "%f",
                specifier: .init(index: .auto, info: .floatingPoint())
            )
            XCTAssert(
                format: "%-f",
                specifier: .init(index: .auto, info: .floatingPoint(alignment: .left))
            )
            XCTAssert(
                format: "%0f",
                specifier: .init(index: .auto, info: .floatingPoint(flags: .zero))
            )
            XCTAssert(
                format: "%1f",
                specifier: .init(index: .auto, info: .floatingPoint(width: .fixed(1)))
            )
            XCTAssert(
                format: "%.2f",
                specifier: .init(index: .auto, info: .floatingPoint(precision: .fixed(2)))
            )
            XCTAssert(
                format: "%1.2f",
                specifier: .init(index: .auto, info: .floatingPoint(width: .fixed(1), precision: .fixed(2)))
            )
        }
        do { // Floating point / Exponent
            XCTAssert(
                format: "%e",
                specifier: .init(index: .auto, info: .floatingPoint(notation: .exponent))
            )
            XCTAssert(
                format: "%-E",
                specifier: .init(index: .auto, info: .floatingPoint(alignment: .left, notation: .exponent, flags: .uppercase))
            )
            XCTAssert(
                format: "%0e",
                specifier: .init(index: .auto, info: .floatingPoint(notation: .exponent, flags: .zero))
            )
            XCTAssert(
                format: "%1e",
                specifier: .init(index: .auto, info: .floatingPoint(width: .fixed(1), notation: .exponent))
            )
            XCTAssert(
                format: "%.2e",
                specifier: .init(index: .auto, info: .floatingPoint(precision: .fixed(2), notation: .exponent))
            )
            XCTAssert(
                format: "%1.2e",
                specifier: .init(index: .auto, info: .floatingPoint(width: .fixed(1), precision: .fixed(2), notation: .exponent))
            )
        }
        do { // Floating point / Hex
            XCTAssert(
                format: "%a",
                specifier: .init(index: .auto, info: .floatingPoint(flags: .hex))
            )
            XCTAssert(
                format: "%-A",
                specifier: .init(index: .auto, info: .floatingPoint(alignment: .left, flags: [ .uppercase, .hex ]))
            )
            XCTAssert(
                format: "%0a",
                specifier: .init(index: .auto, info: .floatingPoint(flags: [ .zero, .hex ]))
            )
            XCTAssert(
                format: "%1a",
                specifier: .init(index: .auto, info: .floatingPoint(width: .fixed(1), flags: .hex))
            )
            XCTAssert(
                format: "%.2a",
                specifier: .init(index: .auto, info: .floatingPoint(precision: .fixed(2), flags: .hex))
            )
            XCTAssert(
                format: "%1.2a",
                specifier: .init(index: .auto, info: .floatingPoint(width: .fixed(1), precision: .fixed(2), flags: .hex))
            )
        }
        do { // Hex
            XCTAssert(
                format: "%x",
                specifier: .init(index: .auto, info: .hex())
            )
            XCTAssert(
                format: "%-x",
                specifier: .init(index: .auto, info: .hex(alignment: .left))
            )
            XCTAssert(
                format: "%#x",
                specifier: .init(index: .auto, info: .hex(flags: .prefix))
            )
            XCTAssert(
                format: "%X",
                specifier: .init(index: .auto, info: .hex(flags: .uppercase))
            )
            XCTAssert(
                format: "%-X",
                specifier: .init(index: .auto, info: .hex(alignment: .left, flags: .uppercase))
            )
            XCTAssert(
                format: "%#X",
                specifier: .init(index: .auto, info: .hex(flags: [ .prefix, .uppercase ]))
            )
        }
        do { // Oct
            XCTAssert(
                format: "%o",
                specifier: .init(index: .auto, info: .oct())
            )
            XCTAssert(
                format: "%-o",
                specifier: .init(index: .auto, info: .oct(alignment: .left))
            )
            XCTAssert(
                format: "%3o",
                specifier: .init(index: .auto, info: .oct(width: .fixed(3)))
            )
        }
        do { // Pointer
            XCTAssert(
                format: "%p",
                specifier: .init(index: .auto, info: .pointer())
            )
            XCTAssert(
                format: "%-p",
                specifier: .init(index: .auto, info: .pointer(alignment: .left))
            )
        }
        do { // Object
            XCTAssert(
                format: "%@",
                specifier: .init(index: .auto, info: .object())
            )
            XCTAssert(
                format: "%-@",
                specifier: .init(index: .auto, info: .object(alignment: .left))
            )
            XCTAssert(
                format: "%10@",
                specifier: .init(index: .auto, info: .object(width: .fixed(10)))
            )
        }
    }
    
}

fileprivate func XCTAssert(
    format: String,
    specifier: Specifier.IEEE_1003,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    do {
        let string = specifier.string
        if string != format {
            XCTFail("Failure convert specifier '\(string)' as \(format)", file: file, line: line)
        }
    }
    do {
        if let parsed = Specifier.IEEE_1003(format) {
            if specifier != parsed {
                XCTFail("Failure compare specifier = \(format)", file: file, line: line)
            }
        } else {
            XCTFail("Failure parse specifier = \(format)", file: file, line: line)
        }
    }
}
