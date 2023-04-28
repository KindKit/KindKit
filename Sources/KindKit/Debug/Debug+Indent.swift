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
        value: String
    ) -> Self {
        return self.append(header: indent)
            .append(value)
            .newline()
    }
    
    @inlinable
    @discardableResult
    func append<
        Value : IDebug
    >(
        header indent: Debug.Indent,
        value: Value
    ) -> Self {
        return self.append(
            header: indent,
            value: value.dump(indent.value)
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
    func append<
        Value : IDebug
    >(
        inter indent: Debug.Indent,
        value: Value
    ) -> Self {
        return self.append(inter: indent)
            .append(value.dump(indent.value))
            .newline()
    }
    
    @inlinable
    @discardableResult
    func append<
        Key : IDebug,
        Value : IDebug
    >(
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
    func append<
        Key : IDebug,
        ValueFormatter : IStringFormatter
    >(
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
        value: String
    ) -> Self {
        return self.append(footer: indent)
            .append(value)
    }
    
    @inlinable
    @discardableResult
    func append<
        Value : IDebug
    >(
        footer indent: Debug.Indent,
        value: Value
    ) -> Self {
        return self.append(
            footer: indent,
            value: value.dump(indent.value)
        )
    }
    
}
