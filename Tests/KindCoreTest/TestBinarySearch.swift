//
//  KindKit-Test
//

import XCTest
import KindCore

class TestBinarySearch : XCTestCase {
    
    func testIndex() {
        do {
            let collection = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ]
            let index = BinarySearch.any(collection, of: 4)
            XCTAssert(index == 4)
        }
        do {
            let collection = [ 0, 0, 1, 1, 2, 2, 3, 3, 4, 4 ]
            let index = BinarySearch.first(collection, of: 1)
            XCTAssert(index == 2)
        }
        do {
            let collection = [ 0, 0, 1, 1, 2, 2, 3, 3, 4, 4 ]
            let index = BinarySearch.first(collection, of: 3)
            XCTAssert(index == 6)
        }
        do {
            let collection = [ 0, 0, 1, 1, 2, 2, 3, 3, 4, 4 ]
            let index = BinarySearch.last(collection, of: 1)
            XCTAssert(index == 3)
        }
        do {
            let collection = [ 0, 0, 1, 1, 2, 2, 3, 3, 4, 4 ]
            let index = BinarySearch.last(collection, of: 3)
            XCTAssert(index == 7)
        }
    }
    
    func testRange() {
        let collection = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ]
        do {
            let range = BinarySearch.range(collection, of: 0 ..< 9)
            XCTAssert(range == 0 ..< 10)
        }
        do {
            let range = BinarySearch.range(collection, of: 0 ..< 2)
            XCTAssert(range == 0 ..< 3)
        }
        do {
            let range = BinarySearch.range(collection, of: 2 ..< 3)
            XCTAssert(range == 2 ..< 4)
        }
        do {
            let range = BinarySearch.range(collection, of: 4 ..< 6)
            XCTAssert(range == 4 ..< 7)
        }
        do {
            let range = BinarySearch.range(collection, of: 7 ..< 8)
            XCTAssert(range == 7 ..< 9)
        }
        do {
            let range = BinarySearch.range(collection, of: 8 ..< 9)
            XCTAssert(range == 8 ..< 10)
        }
    }

}
