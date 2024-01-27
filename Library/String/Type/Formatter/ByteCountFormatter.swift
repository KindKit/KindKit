//
//  KindKit
//

import Foundation
import KindCore
import KindMonadicMacro

@Monadic
public final class ByteCountFormatter : FormatterTrait {
    
    public typealias Internal = Foundation.ByteCountFormatter
    public typealias Input = Int64
    
    public let formatter = Internal()
    
    @MonadicField
    public var units: Internal.Units {
        set { self.formatter.allowedUnits = newValue }
        get { self.formatter.allowedUnits }
    }
    
    @MonadicField
    public var style: Internal.CountStyle {
        set { self.formatter.countStyle = newValue }
        get { self.formatter.countStyle }
    }
    
    public init() {
    }
    
    public func format(_ input: Input) -> String {
        return self.formatter.string(fromByteCount: input)
    }
    
}
