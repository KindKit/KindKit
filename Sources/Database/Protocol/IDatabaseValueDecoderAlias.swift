//
//  KindKitDatabase
//

import Foundation

public protocol IDatabaseValueDecoderAlias {
    
    associatedtype DatabaseValueDecoder : IDatabaseValueDecoder
    
}
