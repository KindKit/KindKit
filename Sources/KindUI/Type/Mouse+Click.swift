//
//  KindKit
//

import KindTime

extension Mouse {
    
    public struct Click : Equatable {
        
        public let button: Mouse.Button
        public let duration: SecondsInterval
        
        public init(
            button: Mouse.Button,
            duration: SecondsInterval
        ) {
            self.button = button
            self.duration = duration
        }
        
    }
    
}
