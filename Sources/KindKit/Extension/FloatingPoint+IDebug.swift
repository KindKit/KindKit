//
//  KindKit
//

import Foundation

extension IDebug where Self : BinaryFloatingPoint & CustomStringConvertible {
    
    public func debugInfo() -> Debug.Info {
        return .string(self.description)
    }

}

extension Float : IDebug {
}

extension Double : IDebug {
}
