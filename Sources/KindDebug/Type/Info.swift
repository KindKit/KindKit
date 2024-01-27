//
//  KindKit
//

import KindCore
import KindString

public indirect enum Info : Hashable, Equatable {
    
    case object(name: String, info: Info)
    case sequence([Info])
    case pair(key: Info, value: Info)
    case string(String)
    
}

public extension Info {
    
    @inlinable
    static func string(@KindString.Builder builder: () -> String) -> Self {
        return .string(builder())
    }
    
}

public extension Info {
    
    @inlinable
    static func cast< Value : IEntity >(
        _ value: Value
    ) -> Self {
        return value.debugInfo()
    }
    
    @inlinable
    static func cast< Value >(
        _ value: Value
    ) -> Self {
        switch value {
        case let value as IEntity: return value.debugInfo()
        default: return .string("\(value)")
        }
    }
    
}

public extension Info {
    
    @inlinable
    static func object(
        name: String,
        info: () -> Info
    ) -> Self {
        return .object(name: name, info: info())
    }
    
    @inlinable
    static func object< Value : IEntity >(
        name: String,
        cast value: Value
    ) -> Self {
        return .object(name: name, info: .cast(value))
    }
    
    @inlinable
    static func object< Value >(
        name: String,
        cast value: Value
    ) -> Self {
        return .object(name: name, info: .cast(value))
    }
    
    @inlinable
    static func object(
        name: String,
        sequence block: (inout [Info]) -> Void
    ) -> Self {
        return .object(name: name, info: .sequence(block))
    }
    
}

public extension Info {
    
    @inlinable
    static func sequence(
        _ block: (inout [Info]) -> Void
    ) -> Self {
        var items: [Info] = []
        block(&items)
        return .sequence(items)
        
    }
    
}

public extension Info {
    
    @inlinable
    static func pair< Key : IEntity, Value : IEntity >(
        cast key: Key,
        cast value: Value
    ) -> Self {
        return .pair(
            key: .cast(key),
            value: .cast(value)
        )
    }
    
    @inlinable
    static func pair< Key : IEntity, Value >(
        cast key: Key,
        cast value: Value
    ) -> Self {
        return .pair(
            key: .cast(key),
            value: .cast(value)
        )
    }
    
    @inlinable
    static func pair< Key, Value : IEntity >(
        cast key: Key,
        cast value: Value
    ) -> Self {
        return .pair(
            key: .cast(key),
            value: .cast(value)
        )
    }
    
    @inlinable
    static func pair< Key, Value >(
        cast key: Key,
        cast value: Value
    ) -> Self {
        return .pair(
            key: .cast(key),
            value: .cast(value)
        )
    }
    
    @inlinable
    static func pair< Value : IEntity >(
        string key: String,
        cast value: Value
    ) -> Self {
        return .pair(
            key: .string(key),
            value: .cast(value)
        )
    }
    
    @inlinable
    static func pair< Value >(
        string key: String,
        cast value: Value
    ) -> Self {
        return .pair(
            key: .string(key),
            value: .cast(value)
        )
    }
    
    @inlinable
    static func pair(
        string key: String,
        string value: String
    ) -> Self {
        return .pair(
            key: .string(key),
            value: .string(value)
        )
    }
    
}

public extension Info {

    func string(
        options: Options = []
    ) -> String {
        return self._builder(options: options)
    }

}

fileprivate extension Info {
    
    @KindString.Builder func _builder(
        options: Options,
        head: Int = 0,
        inter: Int = 1,
        tail: Int = 0
    ) -> String {
        switch self {
        case .object(let type, let value):
            if options.contains(.inline) == false {
                IndentComponent(head)
            }
            LettersComponent("<")
            LettersComponent(type)
            SpaceComponent()
            LettersComponent(
                info: value,
                options: options,
                head: 0,
                inter: inter,
                tail: inter - 1
            )
            SpaceComponent()
            LettersComponent(">")
        case .sequence(let value):
            if options.contains(.inline) == false {
                IndentComponent(head)
                LettersComponent("[")
                NewLineComponent()
            } else {
                LettersComponent("[ ")
            }
            for index in value.indices {
                LettersComponent(
                    info: value[index],
                    options: options,
                    head: inter,
                    inter: inter + 1,
                    tail: inter
                )
                if options.contains(.inline) == true {
                    if index != value.endIndex - 1 {
                        LettersComponent(", ")
                    }
                } else {
                    if index != value.endIndex - 1 {
                        LettersComponent(",")
                    }
                    NewLineComponent()
                }
            }
            if options.contains(.inline) == false {
                IndentComponent(tail)
                LettersComponent("}")
            } else {
                LettersComponent(" }")
            }
        case .pair(let key, let value):
            if options.contains(.inline) == false {
                IndentComponent(head)
            }
            LettersComponent(
                info: key,
                options: options,
                head: 0,
                inter: inter,
                tail: tail
            )
            LettersComponent(": ")
            LettersComponent(
                info: value,
                options: options,
                head: 0,
                inter: inter,
                tail: tail
            )
        case .string(let value):
            if options.contains(.inline) == false {
                IndentComponent(head)
            }
            LettersComponent(value)
        }
    }

}

fileprivate extension LettersComponent {
    
    init(
        info: Info,
        options: Options,
        head: Int,
        inter: Int,
        tail: Int
    ) {
        self.init(info._builder(
            options: options,
            head: head,
            inter: inter,
            tail: tail
        ))
    }
    
}
