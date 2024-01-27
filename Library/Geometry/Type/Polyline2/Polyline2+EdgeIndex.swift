//
//  KindKit
//

import Foundation

extension Polyline2 {
    
    public struct EdgeIndex : Hashable {
        
        public let value: Int
        
        public init(value: Int) {
            self.value = value
        }
        
        public init< Index : BinaryInteger >(_ value: Index) {
            self.value = .init(value)
        }
        
    }
    
}
