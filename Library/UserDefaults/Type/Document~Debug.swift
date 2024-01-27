//
//  KindKit
//

import KindDebug

extension Document : DebugTrait {
    
    public func buildInfo() -> Info {
        guard let representation = self.storage.dictionaryRepresentation() as? DebugTrait else {
            return ObjectInfo(name: "UserDefaults", info: "Empty")
        }
        return ObjectInfo(name: "UserDefaults", info: representation)
    }
    
}

extension Document : CustomStringConvertible {
}

extension Document : CustomDebugStringConvertible {
}
