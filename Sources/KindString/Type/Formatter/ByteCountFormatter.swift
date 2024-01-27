//
//  KindKit
//

import Foundation
import KindCore
import KindMonadicMacro

@KindMonadic
public final class ByteCountFormatter : IFormatter {
    
    public typealias InternalType = Foundation.ByteCountFormatter
    public typealias InputType = Int64
    
    public let formatter = InternalType()
    
    @KindMonadicProperty
    public var units: InternalType.Units {
        set { self.formatter.allowedUnits = newValue }
        get { self.formatter.allowedUnits }
    }
    
    @KindMonadicProperty
    public var style: InternalType.CountStyle {
        set { self.formatter.countStyle = newValue }
        get { self.formatter.countStyle }
    }
    
    public init() {
    }
    
    public func format(_ input: InputType) -> String {
        return self.formatter.string(fromByteCount: input)
    }
    
}

extension ByteCountFormatter : Equatable {
    
    public static func == (lhs: ByteCountFormatter, rhs: ByteCountFormatter) -> Bool {
        return lhs === rhs
    }
    
}
