//
//  KindKit
//

import KindDebug

extension Document : DebugTrait {
    
    public func buildInfo() -> Info {
        guard let root = self.root as? DebugTrait else {
            return ObjectInfo(name: "JSON", info: "Empty")
        }
        return ObjectInfo(name: "JSON", info: root)
    }
    
}

extension Document : CustomStringConvertible {
}

extension Document : CustomDebugStringConvertible {
}
