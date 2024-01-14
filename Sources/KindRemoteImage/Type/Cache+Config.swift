//
//  KindKit
//

import Foundation

public extension Cache {

    struct Config {

        public let memory: Memory
        
        public init(
            memory: Memory = .init()
        ) {
            self.memory = memory
        }
        
    }

}
