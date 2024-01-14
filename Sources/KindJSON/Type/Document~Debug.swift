//
//  KindKit
//

import KindDebug

extension Document : KindDebug.IEntity {
    
    public func debugInfo() -> KindDebug.Info {
        guard let root = self.root as? KindDebug.IEntity else {
            return .object(name: "JSON", info: .string("Empty"))
        }
        return .object(name: "JSON", cast: root)
    }

}

extension Document : CustomStringConvertible {
}

extension Document : CustomDebugStringConvertible {
}
