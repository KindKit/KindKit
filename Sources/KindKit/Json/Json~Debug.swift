//
//  KindKit
//

import Foundation

extension Json : IDebug {
    
    public func debugInfo() -> Debug.Info {
        guard let root = self.root as? IDebug else {
            return .object(name: "Json", info: .string("Empty"))
        }
        return .object(name: "Json", cast: root)
    }

}

extension Json : CustomStringConvertible {
}

extension Json : CustomDebugStringConvertible {
}
