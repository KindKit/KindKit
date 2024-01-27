//
//  KindKit
//

import Foundation

public extension CharacterSet {
    
    @inlinable
    func kk_contains(_ member: Character) -> Bool {
        return member.unicodeScalars.allSatisfy({
            self.contains($0)
        })
    }
    
}
