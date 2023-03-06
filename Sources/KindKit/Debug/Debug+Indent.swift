//
//  KindKit
//

import Foundation

public extension Debug {
    
    struct Indent {
        
        public let header: Int
        public let inter: Int
        public let footer: Int
        
        public init(
            header: Int = 0,
            inter: Int = 1,
            footer: Int = 0
        ) {
            self.header = header
            self.inter = inter
            self.footer = footer
        }
        
    }
    
}

public extension Debug.Indent {
    
    @inlinable
    var value: Self {
        return .init(header: 0, inter: self.inter + 1, footer: self.footer + 1)
    }
    
    @inlinable
    var next: Self {
        return .init(header: self.inter, inter: self.inter + 1, footer: self.inter)
    }
    
}

public extension StringBuilder {
    
    @inlinable
    @discardableResult
    func append(
        header indent: Debug.Indent
    ) -> Self {
        return self.append("\t", repeating: indent.header)
    }
    
    @inlinable
    @discardableResult
    func append(
        header indent: Debug.Indent,
        data: String
    ) -> Self {
        return self.append(header: indent)
            .append(data)
            .newline()
    }
    
    @inlinable
    @discardableResult
    func append< Data : IDebug >(
        header indent: Debug.Indent,
        data: Data
    ) -> Self {
        return self.append(
            header: indent,
            data: data.dump(indent.value)
        )
    }
    
    @inlinable
    @discardableResult
    func append(
        header indent: Debug.Indent,
        data: Any
    ) -> Self {
        if let data = data as? IDebug {
            return self.append(
                header: indent,
                data: data
            )
        }
        return self.append(
            header: indent,
            data: "\(data)"
        )
    }
    
}

public extension StringBuilder {
    
    @inlinable
    @discardableResult
    func append(
        inter indent: Debug.Indent
    ) -> Self {
        return self.append("\t", repeating: indent.inter)
    }
    
    @inlinable
    @discardableResult
    func append< Data : IDebug >(
        inter indent: Debug.Indent,
        data: Data
    ) -> Self {
        return self.append(inter: indent)
            .append(data.dump(indent.value))
            .newline()
    }
    
    @inlinable
    @discardableResult
    func append(
        inter indent: Debug.Indent,
        data: Any
    ) -> Self {
        if let data = data as? IDebug {
            return self.append(
                inter: indent,
                data: data
            )
        }
        return self.append(
            inter: indent,
            data: "\(data)"
        )
    }
    
    @inlinable
    @discardableResult
    func append< Key : IDebug, Value : IDebug >(
        inter indent: Debug.Indent,
        key: Key,
        value: Value
    ) -> Self {
        return self.append(inter: indent)
            .append(key.dump(indent))
            .append(": ")
            .append(value.dump(indent.value))
            .newline()
    }
    
    @inlinable
    @discardableResult
    func append< Value : IDebug >(
        inter indent: Debug.Indent,
        key: Any,
        value: Value
    ) -> Self {
        if let key = key as? IDebug {
            return self.append(
                inter: indent,
                key: key,
                value: value
            )
        }
        return self.append(
            inter: indent,
            key: "\(key)",
            value: value
        )
    }
    
    @inlinable
    @discardableResult
    func append< Key : IDebug >(
        inter indent: Debug.Indent,
        key: Key,
        value: Any
    ) -> Self {
        if let value = value as? IDebug {
            return self.append(
                inter: indent,
                key: key,
                value: value
            )
        }
        return self.append(
            inter: indent,
            key: key,
            value: "\(value)"
        )
    }
    
    @inlinable
    @discardableResult
    func append(
        inter indent: Debug.Indent,
        key: Any,
        value: Any
    ) -> Self {
        if let key = key as? IDebug, let value = value as? IDebug {
            return self.append(
                inter: indent,
                key: key,
                value: value
            )
        } else if let key = key as? IDebug {
            return self.append(
                inter: indent,
                key: key,
                value: value
            )
        } else if let value = value as? IDebug {
            return self.append(
                inter: indent,
                key: key,
                value: value
            )
        }
        return self.append(
            inter: indent,
            key: "\(key)",
            value: "\(value)"
        )
    }
    
    @inlinable
    @discardableResult
    func append< Key : IDebug, ValueFormatter : IStringFormatter >(
        inter indent: Debug.Indent,
        key: Key,
        value: ValueFormatter.InputType,
        valueFormatter: ValueFormatter
    ) -> Self {
        return self.append(
            inter: indent,
            key: key,
            value: valueFormatter.format(value)
        )
    }
    
}

public extension StringBuilder {
    
    @inlinable
    @discardableResult
    func append(
        footer indent: Debug.Indent
    ) -> Self {
        return self.append("\t", repeating: indent.footer)
    }
    
    @inlinable
    @discardableResult
    func append(
        footer indent: Debug.Indent,
        data: String
    ) -> Self {
        return self.append(footer: indent)
            .append(data)
    }
    
    @inlinable
    @discardableResult
    func append< Data : IDebug >(
        footer indent: Debug.Indent,
        data: Data
    ) -> Self {
        return self.append(
            footer: indent,
            data: data.dump(indent.value)
        )
    }
    
    @inlinable
    @discardableResult
    func append(
        footer indent: Debug.Indent,
        data: Any
    ) -> Self {
        if let data = data as? IDebug {
            return self.append(
                footer: indent,
                data: data
            )
        }
        return self.append(
            footer: indent,
            data: "\(data)"
        )
    }
    
}
