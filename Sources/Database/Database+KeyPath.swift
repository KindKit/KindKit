//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public extension Database {
    
    struct KeyPath< ValueDecoderAlias : IDatabaseValueDecoderAlias > : IDatabaseKeyPath {
        
        public typealias ValueDecoder = ValueDecoderAlias.DatabaseValueDecoder
        
        public let index: Database.Index
        
    }

    struct CustomKeyPath< ValueDecoder : IDatabaseValueDecoder > : IDatabaseKeyPath {
        
        public let index: Database.Index
        
    }

}
