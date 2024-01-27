//
//  KindKit
//

import Foundation

public protocol IValueAlias : ITypeAlias {
    
    associatedtype SQLiteValueCoder : IValueCoder
    
}
