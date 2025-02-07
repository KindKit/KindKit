//
//  KindKit
//

import Foundation

public extension Debug {
    
    indirect enum Info : Hashable, Equatable {
        
        case object(name: String, info: Debug.Info)
        case sequence([Debug.Info])
        case pair(key: Debug.Info, value: Debug.Info)
        case string(String)
        case secure(Debug.Info)
        
    }
    
}

public extension Debug.Info {
    
    func visit(sequence block: ([Debug.Info]) -> [Debug.Info]) -> Self {
        guard case .sequence(let sequence) = self else { return self }
        return .sequence(block(sequence))
    }
    
    func visit(sequencePair block: (Debug.Info, Debug.Info) -> Debug.Info?) -> Self {
        return self.visit(sequence: { sequence in
            return sequence.compactMap({
                guard case .pair(let key, let value) = $0 else { return $0 }
                return block(key, value)
            })
        })
    }
    
}

public extension Debug.Info {
    
    @inlinable
    static func cast< Value : IDebug >(
        _ value: Value
    ) -> Self {
        return value.debugInfo()
    }
    
    @inlinable
    static func cast< Value >(
        _ value: Value
    ) -> Self {
        switch value {
        case let value as IDebug: return value.debugInfo()
        default: return .string("\(value)")
        }
    }
    
}

public extension Debug.Info {
    
    @inlinable
    static func object(
        name: String,
        info: () -> Debug.Info
    ) -> Self {
        return .object(name: name, info: info())
    }
    
    @inlinable
    static func object< Value : IDebug >(
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
        sequence block: (inout [Debug.Info]) -> Void
    ) -> Self {
        return .object(name: name, info: .sequence(block))
    }
    
}

public extension Debug.Info {
    
    @inlinable
    static func sequence(
        _ block: (inout [Debug.Info]) -> Void
    ) -> Self {
        var items: [Debug.Info] = []
        block(&items)
        return .sequence(items)
        
    }
    
}

public extension Debug.Info {
    
    @inlinable
    static func pair< Key : IDebug, Value : IDebug >(
        cast key: Key,
        cast value: Value
    ) -> Self {
        return .pair(
            key: .cast(key),
            value: .cast(value)
        )
    }
    
    @inlinable
    static func pair< Key : IDebug, Value >(
        cast key: Key,
        cast value: Value
    ) -> Self {
        return .pair(
            key: .cast(key),
            value: .cast(value)
        )
    }
    
    @inlinable
    static func pair< Key, Value : IDebug >(
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
    static func pair< Value : IDebug >(
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

public extension Debug.Info {

    func string(
        options: Debug.Options = []
    ) -> String {
        let buff = StringBuilder()
        self.processing(
            buff: buff,
            options: options
        )
        return buff.string
    }

}

extension Debug.Info {
    
    @inline(__always)
    func processing(
        buff: StringBuilder,
        options: Debug.Options,
        head: Int = 0,
        inter: Int = 1,
        tail: Int = 0
    ) {
        switch self {
        case .object(let type, let value):
            if options.contains(.inline) == false {
                buff.append("\t", repeating: head)
                    .append("<")
                    .append(type)
                    .append(" ")
            } else {
                buff.append("<")
                    .append(type)
                    .append(" ")
            }
            value.processing(
                buff: buff,
                options: options,
                head: 0,
                inter: inter,
                tail: inter - 1
            )
            buff.append(" >")
        case .sequence(let value):
            if options.contains(.inline) == false {
                buff.append("\t", repeating: head)
                    .append("[")
                    .newline()
            } else {
                buff.append("[ ")
            }
            for index in value.indices {
                let item = value[index]
                item.processing(
                    buff: buff,
                    options: options,
                    head: inter,
                    inter: inter + 1,
                    tail: inter
                )
                if options.contains(.inline) == true {
                    if index != value.endIndex - 1 {
                        buff.append(", ")
                    }
                } else {
                    if index != value.endIndex - 1 {
                        buff.append(",")
                    }
                    buff.newline()
                }
            }
            if options.contains(.inline) == false {
                buff.append("\t", repeating: tail)
                    .append("]")
            } else {
                buff.append(" ]")
            }
        case .pair(let key, let value):
            if options.contains(.inline) == false {
                buff.append("\t", repeating: head)
            }
            key.processing(
                buff: buff,
                options: options,
                head: 0,
                inter: inter,
                tail: tail
            )
            buff.append(": ")
            value.processing(
                buff: buff,
                options: options,
                head: 0,
                inter: inter,
                tail: tail
            )
        case .string(let value):
            if options.contains(.inline) == false {
                buff.append("\t", repeating: head)
            }
            buff.append(value)
        case .secure(let value):
            if options.contains(.allowSecureInfo) == true {
                value.processing(buff: buff, options: options, head: head, inter: inter, tail: tail)
            } else {
                if options.contains(.inline) == false {
                    buff.append("\t", repeating: head)
                }
                buff.append("*****")
            }
        }
    }

}
