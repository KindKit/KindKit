//
//  KindKit
//

import KindStringScanner

public protocol Component {
    
    func scan(_ scanner: Scanner, in context: Pattern.Context) throws
    
}
