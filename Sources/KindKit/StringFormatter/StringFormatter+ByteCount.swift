//
//  KindKit
//

import Foundation

public extension StringFormatter {

    struct ByteCount : IStringFormatter, Equatable {
        
        public typealias InputType = Int64
        
        public let formatter: ByteCountFormatter
        
        public init() {
            self.formatter = ByteCountFormatter()
        }
        
        public func format(_ input: InputType) -> String {
            return self.formatter.string(fromByteCount: input)
        }
        
    }

}

public extension StringFormatter.ByteCount {
    
    @inlinable
    var units: ByteCountFormatter.Units {
        return self.formatter.allowedUnits
    }
    
    @inlinable
    var style: ByteCountFormatter.CountStyle {
        return self.formatter.countStyle
    }
    
}

public extension StringFormatter.ByteCount {
    
    @inlinable
    @discardableResult
    func units(_ value: ByteCountFormatter.Units) -> Self {
        self.formatter.allowedUnits = value
        return self
    }
    
    @inlinable
    @discardableResult
    func style(_ value: ByteCountFormatter.CountStyle) -> Self {
        self.formatter.countStyle = value
        return self
    }
    
}

public extension IStringFormatter where Self == StringFormatter.ByteCount {
    
    static func byteCount() -> Self {
        return .init()
    }
    
}

public extension Int64 {
    
    @inlinable
    func kk_format(byteCount formatter: StringFormatter.ByteCount) -> String {
        return formatter.format(self)
    }
    
}
