//
//  KindKit
//

import KindTime

extension Mouse {
    
    public struct Click : Equatable {
        
        public let location: Point
        public let button: Mouse.Button
        public let duration: SecondsInterval
        
        public init(
            location: Point,
            button: Mouse.Button,
            duration: SecondsInterval
        ) {
            self.location = location
            self.button = button
            self.duration = duration
        }
        
    }
    
}
