//
//  KindKit
//

import Foundation

extension Json : CustomDebugStringConvertible {

    public var debugDescription: String {
        return self.dump()
    }
    
}

extension Json : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        guard let root = self.root as? IDebug else { return }
        root.dump(buff, indent)
    }

}
