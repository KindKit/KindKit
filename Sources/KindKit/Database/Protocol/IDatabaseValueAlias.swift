//
//  KindKit
//

import Foundation

public protocol IDatabaseValueAlias : IDatabaseTypeAlias {
    
    associatedtype DatabaseValueCoder : IDatabaseValueCoder
    
}
