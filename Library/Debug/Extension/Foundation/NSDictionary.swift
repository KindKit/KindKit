//
//  KindKit
//

import Foundation

extension NSDictionary : DebugTrait {
    
    public func buildInfo() -> Info {
        return SequenceInfo(self.map({
            let key: AnyInfo
            if let debug = $0.key as? DebugTrait {
                key = .init(debug.buildInfo())
            } else {
                key = .init(StringInfo(describing: $0.key))
            }
            let value: AnyInfo
            if let debug = $0.value as? DebugTrait {
                value = .init(debug.buildInfo())
            } else {
                value = .init(StringInfo(describing: $0.value))
            }
            return KeyValueInfo(
                key: key,
                value: value
            )
        }))
    }

}
