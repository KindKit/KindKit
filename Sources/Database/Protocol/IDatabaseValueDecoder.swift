//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public protocol IDatabaseValueDecoder : IValueDecoder where Storage == Database.Value {
}

public protocol IDatabaseValueDecoderAlias {
    
    associatedtype DatabaseValueDecoder : IDatabaseValueDecoder
    
}
