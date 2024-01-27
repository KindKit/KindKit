//
//  KindKit
//

import Foundation
import KindStringScanner

extension Pattern {
    
    struct IEEE_1003 : Equatable {
        
        let index: UInt?
        let flags: String
        let width: UInt?
        let precision: UInt?
        let length: String?
        let specifier: String
        
    }
    
}

extension Pattern.IEEE_1003 {
    
    init?(_ string: String) {
        let pattern = KindStringScanner.Pattern(Self.pattern)
        guard let match = try? pattern.match(string) else { return nil }
        self.init(match)
    }
    
    init?(_ match: KindStringScanner.Pattern.Output) {
        guard let specifier = match[string: Keys.specifier] else {
            return nil
        }
        if let index = match[string: Keys.index] {
            self.index = .init(index)
        } else {
            self.index = nil
        }
        if let flags = match[string: Keys.flags] {
            self.flags = flags
        } else {
            self.flags = ""
        }
        if let width = match[string: Keys.width] {
            self.width = .init(width)
        } else {
            self.width = nil
        }
        if let precision = match[string: Keys.precision] {
            self.precision = .init(precision)
        } else {
            self.precision = nil
        }
        self.length = match[string: Keys.length]
        self.specifier = specifier
    }
    
}

extension Pattern.IEEE_1003 {
    
    fileprivate enum Keys : String {
        
        case prefix
        case index
        case flags
        case width
        case precision
        case length
        case specifier
        
    }
    
    @KindStringScanner.ComponentsBuilder
    static func pattern() -> [KindStringScanner.IComponent] {
        CaptureComponent(in: Keys.prefix, {
            ExactComponent(Character("%"))
        })
        OptionalComponent(
            CaptureComponent(in: Keys.index, {
                UntilComponent(CharacterSet.decimalDigits)
                MatchComponent(Character("$"))
            })
        )
        OptionalComponent(
            CaptureComponent(in: Keys.flags, {
                ExactComponent([ "-", "+", " ", "#", "0" ])
            })
        )
        OptionalComponent(
            CaptureComponent(in: Keys.width, {
                UntilComponent(CharacterSet.decimalDigits)
            })
        )
        OptionalComponent(
            GroupComponent({
                MatchComponent(".")
                CaptureComponent(in: Keys.precision, {
                    UntilComponent(CharacterSet.decimalDigits)
                })
            })
        )
        OptionalComponent(
            CaptureComponent(in: Keys.length, {
                ExactComponent([
                    "hh", "h", "ll", "l", "j", "z", "t", "L"
                ])
            })
        )
        CaptureComponent(in: Keys.specifier, {
            ExactComponent([
                "%", "d", "i", "u", "o", "x", "X", "f", "F", "e", "E", "g", "G", "a", "A", "c", "C", "s", "S", "p", "@"
            ])
        })
    }
    
}
