//
//  KindKit-Test
//

import XCTest
import KindSystem

class TestStorage : XCTestCase {
    
    func test1() {
        guard let rootStorage = FileStorage("RootStorage") else {
            return
        }
        guard let rootFile1 = rootStorage.append(name: "RootFile1", extension: "tmp", data: Data()) else {
            return
        }
        guard let subStorage = FileStorage("SubStorage", parent: rootStorage) else {
            return
        }
        guard let subFile1 = subStorage.append(name: "SubFile1", extension: "tmp", data: Data()) else {
            return
        }
        rootStorage.clear(before: .leastNonzeroMagnitude)
        subStorage.clear(before: .leastNonzeroMagnitude)
        rootStorage.delete()
    }

}
