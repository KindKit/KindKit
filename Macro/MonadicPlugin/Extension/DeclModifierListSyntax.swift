//
//  KindKit
//

import SwiftSyntax

extension DeclModifierListSyntax {
    
    struct Contains : OptionSet {
        
        var rawValue: UInt
        
        init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
        static let `internal`: Contains = .init(rawValue: 1 << 0)
        static let internalSet: Contains = .init(rawValue: 1 << 1)
        static let internalGet: Contains = .init(rawValue: 1 << 2)
        
        static let `fileprivate`: Contains = .init(rawValue: 1 << 3)
        static let fileprivateSet: Contains = .init(rawValue: 1 << 4)
        static let fileprivateGet: Contains = .init(rawValue: 1 << 5)
        
        static let `private`: Contains = .init(rawValue: 1 << 6)
        static let privateSet: Contains = .init(rawValue: 1 << 7)
        static let privateGet: Contains = .init(rawValue: 1 << 8)
        
        static let `public`: Contains = .init(rawValue: 1 << 9)
        static let publicSet: Contains = .init(rawValue: 1 << 10)
        static let publicGet: Contains = .init(rawValue: 1 << 11)
        
    }
    
}

extension DeclModifierListSyntax {
    
    var contains: Contains {
        var result = Contains()
        for modifier in self {
            result.insert(modifier.contains)
        }
        return result
    }
    
    var isPublicSet: Bool {
        let contains = self.contains
        if contains.isEmpty {
            return false
        }
        return contains.contains(.public) || contains.contains(.publicSet)
    }
    
    var safe: DeclModifierListSyntax {
        return .init(itemsBuilder: {
            let contains = self.contains
            if contains.isEmpty == false {
                if contains.contains(.internal) || contains.contains(.internalSet) {
                    DeclModifierSyntax.internal
                } else if contains.contains(.fileprivate) || contains.contains(.fileprivateSet) {
                    DeclModifierSyntax.fileprivate
                } else if contains.contains(.private) || contains.contains(.privateSet) {
                    DeclModifierSyntax.private
                } else if contains.contains(.public) || contains.contains(.publicSet) {
                    DeclModifierSyntax.public
                }
            }
        })
    }
    
}
