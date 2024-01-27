//
//  KindKit-Test
//

import XCTest
import KindStringScanner

class TestScanner : XCTestCase {
    
    func test() {
        do {
            let scanner = Scanner("Line 1|Line 2")
            let separator = Character("|")
            XCTAssert(scanner.next(to: separator)?.content == "Line 1")
            XCTAssert(scanner.match(separator) != nil)
            XCTAssert(scanner.next(to: separator)?.content == "Line 2")
        }
        do {
            let scanner = Scanner("Line 1|Line 2")
            let separator = CharacterSet(charactersIn: "|")
            XCTAssert(scanner.next(to: separator)?.content == "Line 1")
            XCTAssert(scanner.match(separator) != nil)
            XCTAssert(scanner.next(to: separator)?.content == "Line 2")
        }
        do {
            let scanner = Scanner("Line 1|Line 2")
            let separator = String("|")
            XCTAssert(scanner.next(to: separator)?.content == "Line 1")
            XCTAssert(scanner.match(separator) != nil)
            XCTAssert(scanner.next(to: separator)?.content == "Line 2")
        }
        do {
            let scanner = Scanner("Line 1|Line 2;Line 3")
            let separators = [ ";", "|" ]
            XCTAssert(scanner.next(to: separators)?.content == "Line 1")
            XCTAssert(scanner.match(separators) != nil)
            XCTAssert(scanner.next(to: separators)?.content == "Line 2")
            XCTAssert(scanner.match(separators) != nil)
            XCTAssert(scanner.next(to: separators)?.content == "Line 3")
        }
    }
    
}
