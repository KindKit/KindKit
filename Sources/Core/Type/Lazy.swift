//
//  KindKitCore
//

import Foundation

public struct Lazy< Value > {
    
    public var value: Value {
        mutating get {
            if self._value == nil {
                self._value = self._supplier()
            }
            return self._value!
        }
    }
    
    private let _supplier: () -> Value
    private var _value: Value?

    public init(_ supplier: @escaping () -> Value) {
        self._supplier = supplier
    }
    
    mutating func clear() {
        self._value = nil
    }

}
