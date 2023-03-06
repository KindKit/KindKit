//
//  KindKit
//

import Foundation

public extension Database {
    
    struct KeyPath< ValueDecoderAlias : IDatabaseValueDecoderAlias > : IDatabaseKeyPath {
        
        public typealias ValueDecoder = ValueDecoderAlias.DatabaseValueDecoder
        
        public let index: Database.Index
        
        public init(_ index: Database.Index) {
            self.index = index
        }
        
    }

    struct CustomKeyPath< ValueDecoder : IDatabaseValueDecoder > : IDatabaseKeyPath {
        
        public let index: Database.Index
        
        public init(_ index: Database.Index) {
            self.index = index
        }
        
    }

}
