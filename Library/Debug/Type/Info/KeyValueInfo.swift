//
//  KindKit
//

import KindCore
import KindString

public struct KeyValueInfo< Key : Info, Value : Info > : Info {
    
    public let key: Key
    public let value: Value
    
    public init(
        key: Key,
        value: Value
    ) {
        self.key = key
        self.value = value
    }
    
    public init(
        key: Info,
        value: Value
    ) where Key == AnyInfo {
        self.key = .init(key)
        self.value = value
    }
    
    public init(
        key: Key,
        value: Info
    ) where Value == AnyInfo {
        self.key = key
        self.value = .init(value)
    }
    
    public init(
        key: Info,
        value: Info
    ) where Key == AnyInfo, Value == AnyInfo {
        self.key = .init(key)
        self.value = .init(value)
    }
    
    public init(
        key: DebugTrait,
        value: Value
    ) where Key == AnyInfo {
        self.key = .init(key.buildInfo())
        self.value = value
    }
    
    public init(
        key: Key,
        value: DebugTrait
    ) where Value == AnyInfo {
        self.key = key
        self.value = .init(value.buildInfo())
    }
    
    public init(
        key: DebugTrait,
        value: DebugTrait
    ) where Key == AnyInfo, Value == AnyInfo {
        self.key = .init(key.buildInfo())
        self.value = .init(value.buildInfo())
    }
    
    @KindString.Builder public func build(
        options: Options,
        head: UInt,
        inter: UInt,
        tail: UInt
    ) -> String {
        if options.contains(.inline) == false {
            IndentComponent(head)
        }
        LettersComponent(
            info: self.key,
            options: options,
            head: 0,
            inter: inter,
            tail: tail
        )
        LettersComponent(": ")
        LettersComponent(
            info: self.value,
            options: options,
            head: 0,
            inter: inter,
            tail: tail
        )
    }
    
}
