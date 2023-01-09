//
//  KindKit
//

import Foundation

public protocol IDebug {

    func dump(_ buff: StringBuilder, _ indent: Debug.Indent)

}

public extension IDebug {
    
    func dump(_ indent: Debug.Indent = .init()) -> String {
        var buff = StringBuilder()
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
        case .none:
            buff.append("nil")
        case .some(let value):
            if let value = value as? IDebug {
                value.dump(buff, indent.value)
            } else {
                buff.append("\(value)")
            }
            break
        }
    }

}

extension Bool : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent).append((self == true) ? "true" : "false")
    }

}

extension String : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent).append("\"\(self.kk_escape(.doubleQuote))\"")
    }

}

extension NSString : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent).append("\"\((self as String).kk_escape(.doubleQuote))\"")
    }

}

extension URL : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent).append("\"\(self.absoluteString)\"")
    }

}

extension NSURL : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        if let url = self.absoluteString {
            buff.append(header: indent).append("\"\(url)\"")
        } else {
            buff.append(header: indent).append("<Url>")
        }
    }

}

extension Data : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent).append("<Data \(self.count) bytes>")
    }

}

extension NSData : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent).append("<Data \(self.length) bytes>")
    }

}

extension NSError : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent, data: "<Error")
            .append(inter: indent, key: "Domain", value: self.domain)
            .append(inter: indent, key: "Code", value: self.code)
            .append(inter: indent, key: "UserInfo", value: self.userInfo)
            .append(footer: indent, data: ">")
    }

}

extension Array : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent, data: "[")
        for item in self {
            buff.append(inter: indent, data: item)
        }
        buff.append(footer: indent, data: "]")
    }

}

extension NSArray : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent, data: "[")
        for item in self {
            buff.append(inter: indent, data: item)
        }
        buff.append(footer: indent, data: "]")
    }

}

extension Dictionary : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent, data: "{")
        for item in self {
            buff.append(inter: indent, key: item.key, value: item.value)
        }
        buff.append(footer: indent, data: "}")
    }

}

extension NSDictionary : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent, data: "{")
        for item in self {
            buff.append(inter: indent, key: item.key, value: item.value)
        }
        buff.append(footer: indent, data: "}")
    }

}
