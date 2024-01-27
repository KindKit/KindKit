//
//  KindKit
//

import Foundation
import KindGraphics
import KindMonadicMacro

@Monadic
public struct Options {
    
    @MonadicField
    public let style: Style?
    
    @MonadicField
    public let flags: TextFlags?
    
    @MonadicField
    public let link: URL?
    
    public init(
        style: Style? = nil,
        flags: TextFlags? = nil,
        link: URL? = nil
    ) {
        self.style = style
        self.flags = flags
        self.link = link
    }
    
}

extension Options : Equatable {
}

extension Options : Sendable {
}

public extension Options {
    
    @inlinable
    static var empty: Self {
        return .init()
    }
    
}

public extension Options {
    
    var isEmpty: Bool {
        return self.style == nil && self.flags == nil && self.link == nil
    }
    
    var `enum`: [Option] {
        var result: [Option] = []
        if let style = self.style {
            result.append(.style(style))
        }
        if let flags = self.flags {
            result.append(.flags(flags))
        }
        if let link = self.link {
            result.append(.link(link))
        }
        return result
    }
    
    var set: OptionSet {
        var result: OptionSet = []
        if self.style != nil {
            result.insert(.style)
        }
        if self.flags != nil {
            result.insert(.flags)
        }
        if self.link != nil {
            result.insert(.link)
        }
        return result
    }
    
}
