//
//  KindKit
//

import Foundation
import KindGraphics
import KindMonadicMacro

extension Text {
    
    @KindMonadic
    public struct Options {
        
        @KindMonadicProperty
        public let style: Style?
        
        @KindMonadicProperty
        public let flags: TextFlags?
        
        @KindMonadicProperty
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
    
}

public extension Text.Options {
    
    static let empty = Self()
    
}

public extension Text.Options {
    
    var isEmpty: Bool {
        return self.style == nil && self.flags == nil && self.link == nil
    }
    
    var `enum`: [Text.Option] {
        var result: [Text.Option] = []
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
    
    var set: Text.OptionSet {
        var result: Text.OptionSet = []
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
