//
//  KindKit
//

import Foundation

extension Data : IEntity {
    
    public func debugInfo() -> Info {
        if let json = try? JSONSerialization.jsonObject(with: self) {
            return (json as! IEntity).debugInfo()
        } else if let string = String(data: self, encoding: .utf8) {
            return .string("\"\(string.kk_escape([ .tab, .newline, .return, .doubleQuote ]))\"")
        }
        return .string("\(self.count) bytes")
    }

}
