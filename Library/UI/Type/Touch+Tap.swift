//
//  KindKit
//

extension Touch {
    
    public struct Tap : Equatable, Hashable {
        
        public let location: Point
        
        public init(
            location: Point
        ) {
            self.location = location
        }
        
    }
    
}
