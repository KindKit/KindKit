//
//  KindKit-Test
//

import XCTest
import KindKit

class TestFileSystemStorage : XCTestCase {
    
    func test1() {
        guard let rootStorage = Storage.FileSystem("RootStorage") else {
            return
        }
        guard let rootFile1 = rootStorage.append(name: "RootFile1", data: Data()) else {
            return
        }
        guard let subStorage = Storage.FileSystem("SubStorage", parent: rootStorage) else {
            return
        }
        guard let subFile1 = subStorage.append(name: "SubFile1", data: Data()) else {
            return
        }
        rootStorage.clear(before: .leastNonzeroMagnitude)
        subStorage.clear(before: .leastNonzeroMagnitude)
        rootStorage.delete()
    }

}
