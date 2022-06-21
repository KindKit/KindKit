//
//  KindKitCode
//

#if DEBUG

import Foundation

public protocol IDebug {

    func debugString() -> String
    func debugString(_ headerIndent: Int, _ indent: Int, _ footerIndent: Int) -> String
    func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int)

}

public extension IDebug {

    func debugString() -> String {
        return self.debugString(0, 1, 0)
    }
    
    func debugString(_ headerIndent: Int, _ indent: Int, _ footerIndent: Int) -> String {
        var buffer = String()
        self.debugString(&buffer, headerIndent, indent, footerIndent)
        return buffer
    }

    func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("\(self)")
    }

}

public func DebugString(_ value: IDebug) -> String {
    return value.debugString()
}

public func DebugString(_ value: IDebug, _ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
    value.debugString(&buffer, headerIndent, indent, footerIndent)
}

extension Int : IDebug {}
extension Int8 : IDebug {}
extension Int16 : IDebug {}
extension Int32 : IDebug {}
extension Int64 : IDebug {}
extension UInt : IDebug {}
extension UInt8 : IDebug {}
extension UInt16 : IDebug {}
extension UInt32 : IDebug {}
extension UInt64 : IDebug {}
extension Float : IDebug {}
extension Double : IDebug {}
extension String : IDebug {}
extension NSString : IDebug {}
extension NSNumber : IDebug {}
extension URL : IDebug {}
extension NSURL : IDebug {}

extension Optional : IDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        switch self {
        case .none:
            if headerIndent > 0 {
                buffer.append(String(repeating: "\t", count: headerIndent))
            }
            buffer.append("nil")
            break
        case .some(let value):
            if let debugValue = value as? IDebug {
                debugValue.debugString(&buffer, 0, indent, footerIndent)
            } else {
                buffer.append("\(value)")
            }
            break
        }
    }

}

extension Bool : IDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append((self == true) ? "true" : "false")
    }

}

extension Data : IDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<Data \(self.count) bytes>")
    }

}

extension NSData : IDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<Data \(self.length) bytes>")
    }

}

extension NSError : IDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let nextIndent = indent + 1
        
        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<NSError\n")
        
        buffer.append(String(repeating: "\t", count: indent))
        buffer.append("Domain: \(self.domain)\n")
        
        buffer.append(String(repeating: "\t", count: indent))
        buffer.append("Code: \(self.code)\n")
        
        var userInfoDebug = String()
        self.userInfo.debugString(&userInfoDebug, 0, nextIndent, indent)
        DebugString("UserInfo: \(userInfoDebug)\n", &buffer, indent, nextIndent, indent)
        
        if footerIndent > 0 {
            buffer.append(String(repeating: "\t", count: footerIndent))
        }
        buffer.append(">\n")
    }

}

extension Array : IDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let nextIndent = indent + 1

        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("[\n")

        self.forEach({ (element) in
            if let debugElement = element as? IDebug {
                debugElement.debugString(&buffer, indent, nextIndent, indent)
            } else {
                if indent > 0 {
                    buffer.append(String(repeating: "\t", count: indent))
                }
                buffer.append("\(element)")
            }
            buffer.append("\n")
        })

        if footerIndent > 0 {
            buffer.append(String(repeating: "\t", count: footerIndent))
        }
        buffer.append("]")
    }

}

extension NSArray : IDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let nextIndent = indent + 1

        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("[\n")

        self.forEach({ (element) in
            if let debugElement = element as? IDebug {
                debugElement.debugString(&buffer, indent, nextIndent, indent)
            } else {
                if indent > 0 {
                    buffer.append(String(repeating: "\t", count: indent))
                }
                buffer.append("\(element)")
            }
            buffer.append("\n")
        })

        if footerIndent > 0 {
            buffer.append(String(repeating: "\t", count: footerIndent))
        }
        buffer.append("]")
    }

}

extension Dictionary : IDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let nextIndent = indent + 1

        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("{\n")

        self.forEach({ (key, value) in
            if let debugKey = key as? IDebug {
                debugKey.debugString(&buffer, indent, nextIndent, 0)
            } else {
                if indent > 0 {
                    buffer.append(String(repeating: "\t", count: indent))
                }
                buffer.append("\(key)")
            }
            buffer.append(" : ")
            if let debugValue = value as? IDebug {
                debugValue.debugString(&buffer, 0, nextIndent, indent)
            } else {
                buffer.append("\(value)")
            }
            buffer.append("\n")
        })

        if footerIndent > 0 {
            buffer.append(String(repeating: "\t", count: footerIndent))
        }
        buffer.append("}")
    }

}

extension NSDictionary : IDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let nextIndent = indent + 1

        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("{\n")

        self.forEach({ (key, value) in
            if let debugKey = key as? IDebug {
                debugKey.debugString(&buffer, indent, nextIndent, 0)
            } else {
                if indent > 0 {
                    buffer.append(String(repeating: "\t", count: indent))
                }
                buffer.append("\(key)")
            }
            buffer.append(" : ")
            if let debugValue = value as? IDebug {
                debugValue.debugString(&buffer, 0, nextIndent, indent)
            } else {
                buffer.append("\(value)")
            }
            buffer.append("\n")
        })

        if footerIndent > 0 {
            buffer.append(String(repeating: "\t", count: footerIndent))
        }
        buffer.append("}")
    }

}

#endif
