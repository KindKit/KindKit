//
//  KindKit
//

import Foundation

public extension Database.ValueDecoder {
    
    struct URL : IDatabaseValueDecoder {
        
        public static func decode(_ value: Database.Value) throws -> Foundation.URL {
            let string = try Database.ValueDecoder.Text.decode(value)
            guard let result = Foundation.URL(string: string) else {
                throw Database.Error.decode
            }
            return result
        }
        
    }
    
}

extension URL : IDatabaseValueDecoderAlias {
    
    public typealias DatabaseValueDecoder = Database.ValueDecoder.URL
    
}
