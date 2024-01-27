//
//  KindKit-Test
//

import XCTest
import KindText

class TestRanges : XCTestCase {
    
    func testInsert() {
        // --- ---
        //    >>
        // ---   ---
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 0, upper: 3), 0)
            ranges.set(.init(lower: 4, upper: 7), 0)
            ranges.insert(3, 2)
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 3, value: 0),
                .init(lower: 6, upper: 9, value: 0)
            ])
        }
        
        // ------
        //    >>>
        // ---------
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 0, upper: 6), 0)
            ranges.insert(3, 3)
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 9, value: 0)
            ])
        }
    }
    
    func testRemove() {
        // ---
        // <<<
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 0, upper: 3), 0)
            ranges.remove(.init(lower: 0, upper: 3))
            XCTAssert(ranges: ranges, expected: [
            ])
        }
        
        //  -
        // <<<
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 1, upper: 2), 0)
            ranges.remove(.init(lower: 0, upper: 3))
            XCTAssert(ranges: ranges, expected: [
            ])
        }
        
        // ---------
        //    <<<
        // ------
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 0, upper: 9), 0)
            ranges.remove(.init(lower: 3, upper: 6))
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 6, value: 0)
            ])
        }
        
        // ---- ----
        //    <<<
        // ---------
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 0, upper: 4), 0)
            ranges.set(.init(lower: 5, upper: 9), 0)
            ranges.remove(.init(lower: 3, upper: 6))
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 6, value: 0)
            ])
        }
        
        // ---- ****
        //    <<<
        // ---***
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 0, upper: 4), 0)
            ranges.set(.init(lower: 5, upper: 9), 1)
            ranges.remove(.init(lower: 3, upper: 6))
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 3, value: 0),
                .init(lower: 3, upper: 6, value: 1)
            ])
        }
        
        // --      **
        //    <<<<
        // --  **
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 0, upper: 2), 0)
            ranges.set(.init(lower: 7, upper: 9), 1)
            ranges.remove(.init(lower: 3, upper: 6))
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 2, value: 0),
                .init(lower: 4, upper: 6, value: 1)
            ])
        }
    }
    
    func testSetMerge() {
        // ---
        //    ---
        //       ---
        // ---------
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 0, upper: 3), 0)
            ranges.set(.init(lower: 3, upper: 6), 0)
            ranges.set(.init(lower: 6, upper: 9), 0)
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 9, value: 0)
            ])
        }
        
        //       ---
        //    ---
        // ---
        // ---------
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 6, upper: 9), 0)
            ranges.set(.init(lower: 3, upper: 6), 0)
            ranges.set(.init(lower: 0, upper: 3), 0)
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 9, value: 0)
            ])
        }
        
        // ---   ---
        //   -----
        // ---------
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 0, upper: 3), 0)
            ranges.set(.init(lower: 6, upper: 9), 0)
            ranges.set(.init(lower: 2, upper: 7), 0)
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 9, value: 0)
            ])
        }
        
        // - - - - -
        // ---------
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 0, upper: 1), 0)
            ranges.set(.init(lower: 2, upper: 3), 0)
            ranges.set(.init(lower: 4, upper: 5), 0)
            ranges.set(.init(lower: 6, upper: 7), 0)
            ranges.set(.init(lower: 8, upper: 9), 0)
            ranges.set(.init(lower: 0, upper: 9), 0)
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 9, value: 0)
            ])
        }
    }
    
    func testSetDifference() {
        // ---
        // ***
        // ***
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 0, upper: 3), 0)
            ranges.set(.init(lower: 0, upper: 3), 1)
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 3, value: 1)
            ])
        }
        
        // ------
        // ***
        // ***---
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 0, upper: 6), 0)
            ranges.set(.init(lower: 0, upper: 3), 1)
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 3, value: 1),
                .init(lower: 3, upper: 6, value: 0)
            ])
        }
        
        // ------
        //    ***
        // ---***
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 0, upper: 6), 0)
            ranges.set(.init(lower: 3, upper: 6), 1)
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 3, value: 0),
                .init(lower: 3, upper: 6, value: 1)
            ])
        }
        
        // -----
        //  ***
        // -***-
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 0, upper: 5), 0)
            ranges.set(.init(lower: 1, upper: 4), 1)
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 1, value: 0),
                .init(lower: 1, upper: 4, value: 1),
                .init(lower: 4, upper: 5, value: 0)
            ])
        }
        
        // ***
        // ------
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 0, upper: 3), 1)
            ranges.set(.init(lower: 0, upper: 6), 0)
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 6, value: 0)
            ])
        }
        
        // ***
        //  -----
        // *-----
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 0, upper: 3), 1)
            ranges.set(.init(lower: 1, upper: 6), 0)
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 1, value: 1),
                .init(lower: 1, upper: 6, value: 0)
            ])
        }
        
        //    ***
        // ------
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 3, upper: 6), 1)
            ranges.set(.init(lower: 0, upper: 6), 0)
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 6, value: 0)
            ])
        }
        
        //    ***
        // -----
        // -----*
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 3, upper: 6), 1)
            ranges.set(.init(lower: 0, upper: 5), 0)
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 5, value: 0),
                .init(lower: 5, upper: 6, value: 1)
            ])
        }
        
        //  ***
        // -----
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 1, upper: 4), 1)
            ranges.set(.init(lower: 0, upper: 5), 0)
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 5, value: 0)
            ])
        }
        
        // ---
        //    ***
        // ---***
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 0, upper: 3), 0)
            ranges.set(.init(lower: 3, upper: 6), 1)
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 3, value: 0),
                .init(lower: 3, upper: 6, value: 1)
            ])
        }
        
        //    ***
        // ---
        // ---***
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 3, upper: 6), 1)
            ranges.set(.init(lower: 0, upper: 3), 0)
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 3, value: 0),
                .init(lower: 3, upper: 6, value: 1)
            ])
        }
        
        // ---------
        // ---***---
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 0, upper: 9), 0)
            ranges.set(.init(lower: 3, upper: 6), 1)
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 3, value: 0),
                .init(lower: 3, upper: 6, value: 1),
                .init(lower: 6, upper: 9, value: 0)
            ])
        }
        
        // ---   ---
        //    ***
        // ---***---
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 0, upper: 3), 0)
            ranges.set(.init(lower: 6, upper: 9), 0)
            ranges.set(.init(lower: 3, upper: 6), 1)
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 3, value: 0),
                .init(lower: 3, upper: 6, value: 1),
                .init(lower: 6, upper: 9, value: 0)
            ])
        }
        
        // ---
        //    ***
        //       +++
        // ---***+++
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 0, upper: 3), 0)
            ranges.set(.init(lower: 3, upper: 6), 1)
            ranges.set(.init(lower: 6, upper: 9), 2)
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 3, value: 0),
                .init(lower: 3, upper: 6, value: 1),
                .init(lower: 6, upper: 9, value: 2)
            ])
        }
        
        //       +++
        //    ***
        // ---
        // ---***+++
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 6, upper: 9), 2)
            ranges.set(.init(lower: 3, upper: 6), 1)
            ranges.set(.init(lower: 0, upper: 3), 0)
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 3, value: 0),
                .init(lower: 3, upper: 6, value: 1),
                .init(lower: 6, upper: 9, value: 2)
            ])
        }
        
        // ---   +++
        //    ***
        // ---***+++
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 0, upper: 3), 0)
            ranges.set(.init(lower: 6, upper: 9), 2)
            ranges.set(.init(lower: 3, upper: 6), 1)
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 3, value: 0),
                .init(lower: 3, upper: 6, value: 1),
                .init(lower: 6, upper: 9, value: 2)
            ])
        }
        
        // ***   ---
        //    ---
        // ***------
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 0, upper: 3), 1)
            ranges.set(.init(lower: 6, upper: 9), 0)
            ranges.set(.init(lower: 3, upper: 6), 0)
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 3, value: 1),
                .init(lower: 3, upper: 9, value: 0)
            ])
        }
        
        // ---   ***
        //    ---
        // ------***
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 0, upper: 3), 0)
            ranges.set(.init(lower: 6, upper: 9), 1)
            ranges.set(.init(lower: 3, upper: 6), 0)
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 6, value: 0),
                .init(lower: 6, upper: 9, value: 1)
            ])
        }
        
        // ---   ---
        //   *****
        // --*****--
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 0, upper: 3), 0)
            ranges.set(.init(lower: 6, upper: 9), 0)
            ranges.set(.init(lower: 2, upper: 7), 1)
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 2, value: 0),
                .init(lower: 2, upper: 7, value: 1),
                .init(lower: 7, upper: 9, value: 0)
            ])
        }
        
        // *********
        // - - - - -
        // -*-*-*-*-
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 0, upper: 9), 1)
            ranges.set(.init(lower: 0, upper: 1), 0)
            ranges.set(.init(lower: 2, upper: 3), 0)
            ranges.set(.init(lower: 4, upper: 5), 0)
            ranges.set(.init(lower: 6, upper: 7), 0)
            ranges.set(.init(lower: 8, upper: 9), 0)
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 1, value: 0),
                .init(lower: 1, upper: 2, value: 1),
                .init(lower: 2, upper: 3, value: 0),
                .init(lower: 3, upper: 4, value: 1),
                .init(lower: 4, upper: 5, value: 0),
                .init(lower: 5, upper: 6, value: 1),
                .init(lower: 6, upper: 7, value: 0),
                .init(lower: 7, upper: 8, value: 1),
                .init(lower: 8, upper: 9, value: 0)
            ])
        }
        
        // *********
        // - - - - -
        // -*-*-*-*-
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 0, upper: 9), 1)
            ranges.set(.init(lower: 8, upper: 9), 0)
            ranges.set(.init(lower: 6, upper: 7), 0)
            ranges.set(.init(lower: 4, upper: 5), 0)
            ranges.set(.init(lower: 2, upper: 3), 0)
            ranges.set(.init(lower: 0, upper: 1), 0)
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 1, value: 0),
                .init(lower: 1, upper: 2, value: 1),
                .init(lower: 2, upper: 3, value: 0),
                .init(lower: 3, upper: 4, value: 1),
                .init(lower: 4, upper: 5, value: 0),
                .init(lower: 5, upper: 6, value: 1),
                .init(lower: 6, upper: 7, value: 0),
                .init(lower: 7, upper: 8, value: 1),
                .init(lower: 8, upper: 9, value: 0)
            ])
        }
    }
    
    func testClear() {
        // ---------
        //    <<<
        // ---   ---
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 0, upper: 9), 0)
            ranges.clear(.init(lower: 3, upper: 6))
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 3, value: 0),
                .init(lower: 6, upper: 9, value: 0)
            ])
        }
        
        // ---- ----
        //    <<<
        // ---------
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 0, upper: 4), 0)
            ranges.set(.init(lower: 5, upper: 9), 0)
            ranges.clear(.init(lower: 3, upper: 6))
            XCTAssert(ranges: ranges, expected: [
                .init(lower: 0, upper: 3, value: 0),
                .init(lower: 6, upper: 9, value: 0)
            ])
        }
        
        //     -
        //    <<<
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 4, upper: 5), 0)
            ranges.clear(.init(lower: 3, upper: 6))
            XCTAssert(ranges: ranges, expected: [
            ])
        }
        
        //    ---
        //    <<<
        do {
            var ranges = Text.Ranges< Int >()
            ranges.set(.init(lower: 3, upper: 6), 0)
            ranges.clear(.init(lower: 3, upper: 6))
            XCTAssert(ranges: ranges, expected: [
            ])
        }
    }
    
}

fileprivate func XCTAssert< ValueType : Equatable >(
    ranges: Text.Ranges< ValueType >,
    expected: [Text.Ranges< ValueType >.Item],
    file: StaticString = #filePath,
    line: UInt = #line
) {
    XCTAssert(ranges.items.count == expected.count, file: file, line: line)
    for index in 0 ..< expected.count {
        let origin = ranges.items[index]
        let expect = expected[index]
        XCTAssert(origin == expect, "\(origin) != \(expect)", file: file, line: line)
    }
}
