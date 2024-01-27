//
//  KindKit
//

import KindLocalize

public extension Key {
    
    @inlinable
    func string(replace arguments: [String : String]) -> String {
        guard let string = self.find else { return "" }
        return string.kk_replace(keys: arguments)
    }
    
}
