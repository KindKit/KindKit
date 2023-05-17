//
//  KindKit
//

import Foundation

public extension Database {
    
    struct KeyPath< Input : IDatabaseValueDecoderAlias > : IDatabaseKeyPath {
        
        public typealias ValueDecoder = Input.DatabaseValueDecoder
        
        public let index: Database.Index
        
        public init(_ index: Database.Index) {
            self.index = index
        }
        
    }

    struct JsonKeyPath< Input : IJsonModelDecoder > : IDatabaseKeyPath {
        
        public typealias ValueDecoder = Database.ValueDecoder.Json< Input >
        
        public let index: Database.Index
        
        public init(_ index: Database.Index) {
            self.index = index
        }
        
    }
    
    struct CustomKeyPath< Input : IDatabaseValueDecoder > : IDatabaseKeyPath {
        
        public typealias ValueDecoder = Input
        
        public let index: Database.Index
        
        public init(_ index: Database.Index) {
            self.index = index
        }
        
    }

}
