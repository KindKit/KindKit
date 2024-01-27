//
//  KindKit
//

extension Cache {

    public struct Config {

        public let memory: Memory
        
        public init(
            memory: Memory = .init()
        ) {
            self.memory = memory
        }
        
    }

}
