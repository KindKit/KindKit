//
//  KindKit
//

import Foundation

extension NSDictionary {
    
    @inlinable
    func kk_trueMap< NewKey : Hashable, NewValue >(_ transform: ((key: Any, value: Any)) -> (key: NewKey, value: NewValue)) -> Dictionary< NewKey, NewValue > {
        var result = Dictionary< NewKey, NewValue >()
        for item in self {
            let new = transform(item)
            result[new.key] = new.value
        }
        return result
    }

}
