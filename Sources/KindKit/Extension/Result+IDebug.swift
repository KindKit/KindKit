//
//  KindKit
//

import Foundation

extension Result : IDebug {
    
    public func debugInfo() -> Debug.Info {
        switch self {
        case .success(let value):
            return .object(name: "Success", cast: value)
        case .failure(let error):
            return .object(name: "Failure", cast: error)
        }
    }
    
}
