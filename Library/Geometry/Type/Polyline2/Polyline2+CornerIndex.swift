//
//  KindKit
//

extension Polyline2 {
    
    public struct CornerIndex : Hashable {
        
        public let value: Int
        
        public init< Other : BinaryInteger >(_ value: Other) {
            self.value = .init(value)
        }
        
    }
    
}
