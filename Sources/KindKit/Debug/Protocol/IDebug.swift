//
//  KindKit
//

import Foundation

public protocol IDebug {

    func dump(_ buff: StringBuilder, _ indent: Debug.Indent)

}

public extension IDebug {
    
    @inlinable
    func dump(_ indent: Debug.Indent = .init()) -> String {
        let buff = StringBuilder()
        self.dump(buff, indent)
        return buff.string
    }

}

extension Int : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent).append("\(self)")
    }
    
}

extension Int8 : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent).append("\(self)")
    }
    
}

extension Int16 : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent).append("\(self)")
    }
    
}

extension Int32 : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent).append("\(self)")
    }
    
}

extension Int64 : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent).append("\(self)")
    }
    
}

extension UInt : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent).append("\(self)")
    }
    
}

extension UInt8 : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent).append("\(self)")
    }
    
}

extension UInt16 : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent).append("\(self)")
    }
    
}

extension UInt32 : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent).append("\(self)")
    }
    
}

extension UInt64 : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent).append("\(self)")
    }
    
}

extension Float : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent).append("\(self)")
    }
    
}

extension Double : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent).append("\(self)")
    }
    
}

extension NSNumber : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent).append("\(self)")
    }
    
}

extension Optional : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent)
        switch self {
        case .some(let value):
            if let value = value as? IDebug {
                value.dump(buff, indent.value)
            } else {
                buff.append("\(value)")
            }
        case .none:
            buff.append("nil")
        }
    }

}

extension Bool : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent).append((self == true) ? "true" : "false")
    }

}

extension NSString : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent).append("\"\((self as String).kk_escape(.doubleQuote))\"")
    }

}

extension NSData : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent).append("<Data \(self.length) bytes>")
    }

}

extension NSError : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(inter: indent, key: "Domain", value: self.domain)
            .append(inter: indent, key: "Code", value: self.code)
            .append(inter: indent, key: "UserInfo", value: self.userInfo)
    }

}

extension NSArray : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent, value: "[")
        for item in self {
            buff.append(inter: indent, value: item)
        }
        buff.append(footer: indent, value: "]")
    }

}

extension NSDictionary : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent, value: "{")
        for item in self {
            buff.append(inter: indent, key: item.key, value: item.value)
        }
        buff.append(footer: indent, value: "}")
    }

}
