//
//  KindKit-Test
//

import Testing
import KindCore

struct BinarySearchTest {
    
    @Test
    func index() {
        do {
            let collection = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ]
            let index = BinarySearch.any(collection, of: 4)
            #expect(index == 4)
        }
        do {
            let collection = [ 0, 0, 1, 1, 2, 2, 3, 3, 4, 4 ]
            let index = BinarySearch.first(collection, of: 1)
            #expect(index == 2)
        }
        do {
            let collection = [ 0, 0, 1, 1, 2, 2, 3, 3, 4, 4 ]
            let index = BinarySearch.first(collection, of: 3)
            #expect(index == 6)
        }
        do {
            let collection = [ 0, 0, 1, 1, 2, 2, 3, 3, 4, 4 ]
            let index = BinarySearch.last(collection, of: 1)
            #expect(index == 3)
        }
        do {
            let collection = [ 0, 0, 1, 1, 2, 2, 3, 3, 4, 4 ]
            let index = BinarySearch.last(collection, of: 3)
            #expect(index == 7)
        }
    }
    
    @Test
    func range() {
        let collection = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ]
        do {
            let range = BinarySearch.range(collection, of: 0 ..< 9)
            #expect(range == 0 ..< 10)
        }
        do {
            let range = BinarySearch.range(collection, of: 0 ..< 2)
            #expect(range == 0 ..< 3)
        }
        do {
            let range = BinarySearch.range(collection, of: 2 ..< 3)
            #expect(range == 2 ..< 4)
        }
        do {
            let range = BinarySearch.range(collection, of: 4 ..< 6)
            #expect(range == 4 ..< 7)
        }
        do {
            let range = BinarySearch.range(collection, of: 7 ..< 8)
            #expect(range == 7 ..< 9)
        }
        do {
            let range = BinarySearch.range(collection, of: 8 ..< 9)
            #expect(range == 8 ..< 10)
        }
    }

}
